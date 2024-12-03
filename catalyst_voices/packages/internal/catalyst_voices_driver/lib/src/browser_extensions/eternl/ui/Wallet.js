import { es as getRequestData, et as ApiRequestType, eu as ErrorSync, ev as DEFAULT_ACCOUNT_ID, d as defineComponent, o as openBlock, c as createElementBlock, e as createBaseVNode, u as unref, q as createVNode, a as createBlock, j as createCommentVNode, b as withModifiers, z as ref, D as watch, h as withCtx, H as Fragment, I as renderList, ae as useSelectedAccount, b3 as toHexString, V as nextTick, K as networkId, s as selectedAccountId, ew as cryptoBrowserifyExports, n as normalizeClass, i as createTextVNode, t as toDisplayString, C as onMounted, aW as addSignalListener, aQ as onNetworkFeaturesUpdated, aG as onUnmounted, aX as removeSignalListener, aV as useRoute, w as watchEffect, ab as withKeys, Q as QSpinnerDots_default, v as isNormalMode, bN as isIosApp, x as isSignMode, cf as getRandomId, a9 as timestampLocal, k as dispatchSignalSync, da as doToggleDappAccountId, r as resolveComponent } from "./index.js";
import { _ as _sfc_main$f } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { e as isStakingEnabled, m as isSwapEnabled, o as isCatalystEnabled, p as isGovernanceEnabled } from "./NetworkId.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$5, a as _sfc_main$7 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { d as doOpenWalletSettings } from "./signals.js";
import { _ as _sfc_main$a, a as _sfc_main$b } from "./WalletIcon.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$8 } from "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$6 } from "./ExternalLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$9 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$c, a as _sfc_main$d, b as _sfc_main$e } from "./SettingsDangerZone.vue_vue_type_script_setup_true_lang.js";
import { r as removeBackground, s as setWalletBackground } from "./ExtBackground.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import "./GridSpace.js";
import "./useTabId.js";
import "./useBalanceVisible.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./Clipboard.js";
import "./lz-string.js";
import "./GridButtonSecondary.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./IconPencil.js";
import "./GridInput.js";
import "./IconError.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import "./image.js";
import "./GridFormWalletName.vue_vue_type_script_setup_true_lang.js";
import "./GFEWalletName.vue_vue_type_script_setup_true_lang.js";
import "./GridInputAutocomplete.js";
import "./GridFormPasswordReset.vue_vue_type_script_setup_true_lang.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import "./GFERepeatPassword.vue_vue_type_script_setup_true_lang.js";
import "./useDownload.js";
import "./SettingsItem.vue_vue_type_script_setup_true_lang.js";
import "./browser.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import "./useTrezorDevice.js";
import "./Keystone.vue_vue_type_script_setup_true_lang.js";
import "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import "./AccessPasswordInputModal.vue_vue_type_script_setup_true_lang.js";
import "./ScanQrCode.vue_vue_type_script_setup_true_lang.js";
import "./QrcodeStream.js";
import "./scanner.js";
import "./useAdaSymbol.js";
import "./GridAccountUtxoItem.vue_vue_type_script_setup_true_lang.js";
import "./IconButton.vue_vue_type_script_setup_true_lang.js";
import "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
import "./GridToggle.vue_vue_type_script_setup_true_lang.js";
const getFiatProviders = (networkId2, accountId) => {
  if (!accountId) {
    accountId = DEFAULT_ACCOUNT_ID;
  }
  return getRequestData()(
    networkId2,
    accountId,
    ApiRequestType.getFiatProviders,
    ErrorSync.getFiatProviders,
    {
      id: accountId
    },
    async (data) => typeof data === "object" && data.providers ? data.providers : null
  );
};
const _hoisted_1$4 = { class: "flex-none" };
const _hoisted_2$4 = ["src"];
const _hoisted_3$3 = { class: "w-full grid-cols-12" };
const _hoisted_4$1 = ["innerHTML"];
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "OnOffRampItem",
  props: {
    provider: { type: Object, required: true }
  },
  emits: ["providerSelected"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const icon = props.provider.icon;
    const emit = __emit;
    function onFiatProviderSelected() {
      emit("providerSelected", props.provider);
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: "relative cc-text-sz flex flex-row flex-nowrap justify-start cc-area-light items-start cursor-pointer p-4 gap-4",
        onClick: withModifiers(onFiatProviderSelected, ["stop"])
      }, [
        createBaseVNode("div", _hoisted_1$4, [
          createBaseVNode("img", {
            class: "cc-icon-round-lg",
            loading: "lazy",
            src: unref(icon),
            alt: "network logo",
            onError: _cache[0] || (_cache[0] = ($event) => icon.value = "")
          }, null, 40, _hoisted_2$4)
        ]),
        createBaseVNode("div", _hoisted_3$3, [
          createVNode(_sfc_main$5, {
            label: __props.provider.name
          }, null, 8, ["label"]),
          createBaseVNode("div", {
            innerHTML: __props.provider.description,
            class: "col-span-12"
          }, null, 8, _hoisted_4$1),
          __props.provider.link ? (openBlock(), createBlock(_sfc_main$6, {
            key: 0,
            url: __props.provider.link.url,
            label: __props.provider.link.label ?? __props.provider.link.url,
            "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
            class: "mt-2 whitespace-nowrap"
          }, null, 8, ["url", "label"])) : createCommentVNode("", true)
        ])
      ]);
    };
  }
});
const _hoisted_1$3 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$3 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$2 = {
  key: 1,
  class: "p-4 flex flex-col flex-nowrap gap-2"
};
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "OnOffRamp",
  props: {
    showOnOffRampModal: { type: Boolean, required: true, default: false }
  },
  emits: ["close"],
  setup(__props, { emit: __emit }) {
    const crypto = typeof self !== "undefined" ? self.crypto : cryptoBrowserifyExports.webcrypto;
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { gotoWalletPage } = useNavigation();
    const { accountSettings } = useSelectedAccount();
    const receiveAddress = accountSettings.receiveAddress;
    const providers = ref(null);
    async function onProviderSelected(provider) {
      var _a;
      const _receiveAddress = ((_a = receiveAddress.value) == null ? void 0 : _a.bech32) ?? "";
      let url = provider.url.replace(/###address###/g, _receiveAddress);
      if (url.includes("###sha512addresssig###")) {
        const textEnc = new TextEncoder("utf-8");
        const hash = await crypto.subtle.digest("SHA-512", textEnc.encode(_receiveAddress + "eternl"));
        const sig = toHexString(new Uint8Array(hash));
        url = url.replace("###sha512addresssig###", sig);
      }
      window.open(url, void 0, "noopener,noreferrer");
      gotoWalletPage("Receive");
      nextTick(() => {
        emit("close");
      });
    }
    async function fetchFiatProviders() {
      try {
        providers.value = await getFiatProviders(networkId.value, selectedAccountId.value);
      } catch (e) {
        console.error("fetchFiatProviders", e);
      }
    }
    watch(() => props.showOnOffRampModal, (showModal) => {
      providers.value = null;
      if (showModal) {
        fetchFiatProviders();
      }
    });
    return (_ctx, _cache) => {
      return __props.showOnOffRampModal ? (openBlock(), createBlock(Modal, {
        key: 0,
        narrow: "",
        "full-width-on-mobile": "",
        onClose: _cache[0] || (_cache[0] = ($event) => _ctx.$emit("close"))
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1$3, [
            createBaseVNode("div", _hoisted_2$3, [
              createVNode(_sfc_main$5, {
                label: unref(it)("wallet.onofframp.headline")
              }, null, 8, ["label"]),
              createVNode(_sfc_main$7, {
                text: unref(it)("wallet.onofframp.caption")
              }, null, 8, ["text"])
            ])
          ])
        ]),
        content: withCtx(() => [
          createVNode(_sfc_main$8, {
            label: unref(it)("wallet.onofframp.loading"),
            active: providers.value === null
          }, null, 8, ["label", "active"]),
          !!providers.value && providers.value.length === 0 ? (openBlock(), createBlock(_sfc_main$7, {
            key: 0,
            text: unref(it)("wallet.onofframp.noprovider")
          }, null, 8, ["text"])) : !!providers.value ? (openBlock(), createElementBlock("div", _hoisted_3$2, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(providers.value, (provider, index) => {
              return openBlock(), createElementBlock("div", { key: index }, [
                createVNode(_sfc_main$4, {
                  provider,
                  onProviderSelected
                }, null, 8, ["provider"])
              ]);
            }), 128))
          ])) : createCommentVNode("", true)
        ]),
        _: 1
      })) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$2 = { class: "relative w-6 h-6 flex flex-col flex-nowrap items-center justify-center" };
const _hoisted_2$2 = ["innerHTML"];
const _hoisted_3$1 = ["innerHTML"];
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "TabButton",
  props: {
    label: { type: String, required: false, default: null },
    labelShort: { type: String, required: false, default: null },
    labelCSS: { type: String, required: false, default: "" },
    labelOnHover: { type: Boolean, default: false },
    icon: { type: String, required: false, default: null },
    iconCSS: { type: String, required: false, default: "text-xl" },
    buttonCSS: { type: String, required: false, default: "" },
    borderCSS: { type: String, required: false, default: "" },
    borderActiveCSS: { type: String, required: false, default: "" },
    link: { type: String, default: void 0 },
    active: { type: Boolean, default: false }
  },
  emits: ["clicked"],
  setup(__props, { emit: __emit }) {
    useTranslation();
    const {
      gotoWalletPage
    } = useNavigation();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        class: normalizeClass(["relative group cc-border-reset flex flex-col md:flex-row flex-nowrap items-center justify-center border-b-2 px-1 min-w-0 xs:min-w-12 sm:min-w-16 cc-text-medium text-xs md:text-sm lg:text-sm capitalize", __props.buttonCSS + " " + (__props.active ? "cc-menu-button-active " + __props.borderActiveCSS : "cc-menu-button " + __props.borderCSS) + " "]),
        onClick: _cache[0] || (_cache[0] = withModifiers(($event) => {
          __props.link && unref(gotoWalletPage)(__props.link);
          _ctx.$emit("clicked");
        }, ["stop"]))
      }, [
        createBaseVNode("div", _hoisted_1$2, [
          __props.icon ? (openBlock(), createElementBlock("i", {
            key: 0,
            class: normalizeClass(["max-h-full mdi", __props.icon + " " + __props.iconCSS + " " + (__props.label && !__props.labelOnHover ? "md:mr-1.5" : "")])
          }, null, 2)) : createCommentVNode("", true)
        ]),
        __props.label && !__props.labelOnHover ? (openBlock(), createElementBlock("span", {
          key: 0,
          class: normalizeClass(["cc-none xs:block whitespace-nowrap text-left mt-px w-full text-center", __props.labelCSS]),
          innerHTML: __props.label
        }, null, 10, _hoisted_2$2)) : createCommentVNode("", true),
        __props.labelShort && !__props.labelOnHover ? (openBlock(), createElementBlock("span", {
          key: 1,
          class: normalizeClass(["xs:hidden whitespace-nowrap text-left mt-px w-full text-center", __props.labelCSS]),
          innerHTML: __props.labelShort
        }, null, 10, _hoisted_3$1)) : createCommentVNode("", true),
        __props.label && __props.labelOnHover ? (openBlock(), createBlock(_sfc_main$9, {
          key: 2,
          anchor: "top middle",
          offset: [0, 26],
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => [
            createTextVNode(toDisplayString(__props.label), 1)
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ], 2);
    };
  }
});
const _hoisted_1$1 = { class: "h-16 md:h-20 w-full max-w-full flex flex-row flex-nowrap justify-center items-center border-t border-b mb-px cc-text-sx-dense cc-bg-white-0 overflow-hidden" };
const _hoisted_2$1 = { class: "relative w-full h-full flex flex-row flex-nowrap justify-between items-center max-w-6xl px-1 xxs:px-3 lg:px-6 xl:px-6 space-x-2" };
const _hoisted_3 = { class: "relative mr-2 block h-8 sm:h-10 w-8 sm:w-10" };
const _hoisted_4 = {
  key: 0,
  class: "relative h-full flex-1 flex flex-col flex-nowrap justify-center items-start cc-text-semi-bold"
};
const _hoisted_5 = { class: "mb-0.5 flex flex-row" };
const _hoisted_6 = {
  key: 0,
  class: "mdi mdi-circle text-xs-dense ml-1 mt-1.5 cc-text-green",
  style: { "line-height": "0.0rem" }
};
const _hoisted_7 = {
  key: 2,
  class: "h-0 ml-1"
};
const _hoisted_8 = {
  key: 1,
  class: "cc-text-color-caption cc-text-xxs-dense cc-text-medium"
};
const _hoisted_9 = { key: 1 };
const _hoisted_10 = { key: 0 };
const _hoisted_11 = { key: 1 };
const _hoisted_12 = { key: 2 };
const _hoisted_13 = { key: 3 };
const _hoisted_14 = { key: 2 };
const _hoisted_15 = { key: 3 };
const _hoisted_16 = { key: 4 };
const _hoisted_17 = { key: 5 };
const _hoisted_18 = {
  key: 6,
  class: "font-mono"
};
const _hoisted_19 = { key: 7 };
const _hoisted_20 = {
  key: 8,
  class: "font-mono"
};
const _hoisted_21 = { key: 9 };
const _hoisted_22 = {
  key: 0,
  xmlns: "http://www.w3.org/2000/svg",
  viewBox: "0 0 24 24",
  class: "cc-fill-green w-full h-full"
};
const _hoisted_23 = {
  key: 1,
  xmlns: "http://www.w3.org/2000/svg",
  viewBox: "0 0 24 24",
  class: "cc-fill w-full h-full"
};
const _hoisted_24 = {
  key: 0,
  class: "relative h-full flex-1 flex flex-col flex-nowrap justify-center items-end cc-text-semi-bold"
};
const _hoisted_25 = { class: "mb-0.5 flex flex-row" };
const _hoisted_26 = {
  key: 0,
  class: "h-0 mr-1"
};
const _hoisted_27 = {
  key: 1,
  class: "mdi mdi-circle text-xs-dense mr-1 mt-2 cc-text-green",
  style: { "line-height": "0.0rem" }
};
const _hoisted_28 = {
  key: 0,
  class: "w-full max-w-full flex flex-col flex-nowrap justify-center items-center border-t border-b cc-menu-group"
};
const _hoisted_29 = {
  class: "relative overflow-x-auto overflow-hidden w-full flex flex-row flex-nowrap items-start justify-center px-2.5 space-x-1.5 xxs:space-x-1 sm:space-x-0 md:space-x-1",
  "aria-label": "Tabs"
};
const _hoisted_30 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_31 = { class: "flex flex-col cc-text-sz" };
const _hoisted_32 = { class: "p-4" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "WalletHeader",
  setup(__props) {
    const storeId = "WalletHeader" + getRandomId();
    const {
      selectedWalletId,
      appWallet,
      walletSettings,
      selectedAccountId: selectedAccountId2,
      appAccount,
      accountSettings
    } = useSelectedAccount();
    const walletName = walletSettings.name;
    const walletBalance = walletSettings.balance;
    const isWalletSyncing = walletSettings.isSyncing;
    const plate = walletSettings.plate;
    const background = walletSettings.background;
    const accountName = accountSettings.name;
    const accountBalance = accountSettings.balance;
    const isAccountSyncing = accountSettings.isSyncing;
    const isManualSyncEnabled = accountSettings.isManualSyncEnabled;
    const openSetting = ref("");
    const showModal = ref(false);
    const showOnOffRampModal = ref(false);
    const openSettingsModal = (setting) => {
      showModal.value = true;
      openSetting.value = setting ?? "";
    };
    const onClose = () => {
      showModal.value = false;
      openSetting.value = "";
    };
    let stakeIsEnabled = isStakingEnabled(networkId.value);
    let swapIsEnabled = isSwapEnabled(networkId.value);
    let catalystIsEnabled = isCatalystEnabled(networkId.value);
    let governanceIsEnabled = isGovernanceEnabled(networkId.value);
    const _onNetworkFeaturesUpdated = () => {
      stakeIsEnabled = isStakingEnabled(networkId.value);
      swapIsEnabled = isSwapEnabled(networkId.value);
      catalystIsEnabled = isCatalystEnabled(networkId.value);
      governanceIsEnabled = isGovernanceEnabled(networkId.value);
      createMenu();
    };
    onMounted(() => {
      addSignalListener(doOpenWalletSettings, storeId, openSettingsModal);
      addSignalListener(onNetworkFeaturesUpdated, storeId, _onNetworkFeaturesUpdated);
    });
    onUnmounted(() => {
      removeSignalListener(doOpenWalletSettings, storeId);
      removeSignalListener(onNetworkFeaturesUpdated, storeId);
    });
    const route = useRoute();
    const {
      gotoWalletPage
    } = useNavigation();
    const { it } = useTranslation();
    const options = ref([]);
    function createMenu() {
      let menuOptions = [
        {
          position: 1,
          label: it("menu.wallet.account.label"),
          labelShort: it("menu.wallet.account.labelShort"),
          icon: it("menu.wallet.account.icon"),
          link: "Summary",
          selected: true
        },
        {
          position: 2,
          label: it("menu.wallet.transactions.label"),
          labelShort: it("menu.wallet.transactions.labelShort"),
          icon: it("menu.wallet.transactions.icon"),
          link: "Transactions",
          selected: false
        },
        {
          position: 3,
          label: it("menu.wallet.send.label"),
          labelShort: it("menu.wallet.send.labelShort"),
          icon: it("menu.wallet.send.icon"),
          link: "Send",
          selected: false
        },
        {
          position: 5,
          label: it("menu.wallet.receive.label"),
          labelShort: it("menu.wallet.receive.labelShort"),
          icon: it("menu.wallet.receive.icon"),
          link: "Receive",
          selected: false
        }
      ];
      if (swapIsEnabled) {
        menuOptions.push(
          {
            position: 4,
            label: it("menu.wallet.swap.label"),
            labelShort: it("menu.wallet.swap.labelShort"),
            icon: it("menu.wallet.swap.icon"),
            link: "Swap",
            selected: false
          }
        );
      }
      if (stakeIsEnabled) {
        menuOptions.push(
          {
            position: 6,
            label: it("menu.wallet.staking.label"),
            labelShort: it("menu.wallet.staking.labelShort"),
            icon: it("menu.wallet.staking.icon"),
            link: "Staking",
            selected: false
          }
        );
      }
      if (catalystIsEnabled || governanceIsEnabled) {
        menuOptions.push(
          {
            position: 7,
            label: it("menu.wallet.voting.label"),
            labelShort: it("menu.wallet.voting.labelShort"),
            icon: it("menu.wallet.voting.icon"),
            link: "Voting",
            selected: false
          }
        );
      }
      menuOptions.push(
        {
          position: 99,
          label: it("menu.wallet.settings.label"),
          labelShort: it("menu.wallet.settings.labelShort"),
          icon: it("menu.wallet.settings.icon"),
          func: openSettingsModal,
          selected: false
        }
      );
      options.value.splice(0, options.value.length, ...menuOptions.sort((a, b) => a.position - b.position));
    }
    createMenu();
    const lastSync1 = ref("");
    const lastSync2 = ref("");
    const lastWalledId = ref(null);
    watchEffect(() => {
      var _a;
      const _ts = timestampLocal.value;
      const syncInfo = ((_a = appAccount.value) == null ? void 0 : _a.syncInfo) ?? null;
      if (!syncInfo || syncInfo.info === "default") {
        lastSync1.value = "";
        lastSync2.value = "";
      } else {
        let ls = syncInfo.stateTimestamp;
        if (ls <= 0 && isManualSyncEnabled.value) {
          lastSync1.value = "";
          lastSync2.value = "";
          return;
        }
        ls = Math.floor(ls > 0 ? ls : _ts);
        let totalSeconds = Math.max(Math.floor((_ts - ls) / 1e3), -1) + 1;
        let _seconds = totalSeconds % 60;
        let _minutes = Math.floor(totalSeconds / 60) % 60;
        let _hours = Math.floor(totalSeconds / 3600) % 24;
        let _days = Math.floor(totalSeconds / 86400);
        if (totalSeconds < 60) {
          lastSync1.value = "";
          lastSync2.value = _seconds + "s";
        } else if (totalSeconds < 3600) {
          lastSync1.value = _minutes + "m";
          lastSync2.value = _seconds + "s";
        } else if (totalSeconds < 86400) {
          lastSync1.value = _hours + "h";
          lastSync2.value = _minutes + "m";
        } else {
          lastSync1.value = _days + "d";
          lastSync2.value = _hours + "h";
        }
        if (networkId.value && lastWalledId.value !== selectedWalletId.value) {
          removeBackground();
          if (background.value.policy) {
            setWalletBackground(networkId.value, background.value);
          }
        }
        lastWalledId.value = selectedWalletId.value ?? "";
      }
    });
    function gotoAccountList() {
      if (isSignMode()) ;
      else {
        gotoWalletPage("Summary", "accounts");
      }
    }
    function onSetDAppAccount() {
      dispatchSignalSync(doToggleDappAccountId, selectedWalletId.value, selectedAccountId2.value);
    }
    function onOpenOnOffRampModal() {
      showOnOffRampModal.value = true;
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", _hoisted_1$1, [
          createBaseVNode("div", _hoisted_2$1, [
            createBaseVNode("div", {
              class: "flex-none cc-btn-tertiary-light cc-area-light-1 flex w-auto min-w-48 sm:min-w-60 h-12 sm:h-14 flex-row flex-nowrap justify-start items-start px-2 py-2 cursor-pointer",
              onKeydown: [
                _cache[0] || (_cache[0] = withKeys(($event) => gotoAccountList(), ["enter"])),
                _cache[1] || (_cache[1] = withKeys(($event) => gotoAccountList(), ["space"]))
              ],
              onClick: _cache[2] || (_cache[2] = withModifiers(($event) => gotoAccountList(), ["stop"])),
              tabindex: "0"
            }, [
              createBaseVNode("div", _hoisted_3, [
                createVNode(_sfc_main$a, {
                  "icon-seed": unref(plate).image ?? void 0,
                  "icon-data": unref(plate).data ?? void 0
                }, null, 8, ["icon-seed", "icon-data"])
              ]),
              unref(appWallet) ? (openBlock(), createElementBlock("div", _hoisted_4, [
                createBaseVNode("div", _hoisted_5, [
                  createTextVNode(toDisplayString(unref(walletName)) + " ", 1),
                  unref(appWallet).isDappWallet ? (openBlock(), createElementBlock("i", _hoisted_6)) : createCommentVNode("", true),
                  unref(appWallet).isReadOnly ? (openBlock(), createElementBlock("i", {
                    key: 1,
                    class: normalizeClass(["mdi mdi-cash-lock text-md ml-1 mt-1.5 cc-text-highlight", unref(appWallet).isDappWallet ? "ml-1" : ""]),
                    style: { "line-height": "0.1rem" }
                  }, null, 2)) : createCommentVNode("", true),
                  unref(isWalletSyncing) ? (openBlock(), createElementBlock("div", _hoisted_7, [
                    createVNode(QSpinnerDots_default, {
                      color: "gray",
                      size: "1rem"
                    })
                  ])) : createCommentVNode("", true)
                ]),
                unref(walletBalance) ? (openBlock(), createBlock(_sfc_main$b, {
                  key: 0,
                  balance: unref(walletBalance),
                  syncInfo: unref(appWallet).syncInfo,
                  syncing: unref(isWalletSyncing),
                  field: "total",
                  "hide-sync-button": "",
                  "hide-currency": ""
                }, null, 8, ["balance", "syncInfo", "syncing"])) : createCommentVNode("", true),
                unref(appAccount) ? (openBlock(), createElementBlock("span", _hoisted_8, [
                  unref(isManualSyncEnabled) ? (openBlock(), createBlock(_sfc_main$9, {
                    key: 0,
                    anchor: "bottom middle",
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(it)("wallet.manualsync.info")) + " ", 1),
                      _cache[4] || (_cache[4] = createBaseVNode("i", { class: "mdi mdi-sync" }, null, -1)),
                      _cache[5] || (_cache[5] = createTextVNode(". "))
                    ]),
                    _: 1
                  })) : createCommentVNode("", true),
                  unref(isManualSyncEnabled) ? (openBlock(), createElementBlock("span", _hoisted_9, [
                    _cache[6] || (_cache[6] = createTextVNode("Manual, ")),
                    unref(appAccount).syncInfo.isInitializing && unref(isAccountSyncing) ? (openBlock(), createElementBlock("span", _hoisted_10, " preparing for")) : unref(isAccountSyncing) ? (openBlock(), createElementBlock("span", _hoisted_11, " syncing for")) : !(lastSync1.value || lastSync2.value) && unref(isManualSyncEnabled) ? (openBlock(), createElementBlock("span", _hoisted_12, " not synced yet")) : (openBlock(), createElementBlock("span", _hoisted_13, " synced"))
                  ])) : unref(appAccount).syncInfo.isInitializing ? (openBlock(), createElementBlock("span", _hoisted_14, "Initializing")) : unref(isAccountSyncing) ? (openBlock(), createElementBlock("span", _hoisted_15, "Syncing for")) : (openBlock(), createElementBlock("span", _hoisted_16, "Synced")),
                  lastSync1.value ? (openBlock(), createElementBlock("span", _hoisted_17, " ")) : createCommentVNode("", true),
                  lastSync1.value ? (openBlock(), createElementBlock("span", _hoisted_18, toDisplayString(lastSync1.value), 1)) : createCommentVNode("", true),
                  lastSync2.value ? (openBlock(), createElementBlock("span", _hoisted_19, " ")) : createCommentVNode("", true),
                  lastSync2.value ? (openBlock(), createElementBlock("span", _hoisted_20, toDisplayString(lastSync2.value), 1)) : createCommentVNode("", true),
                  (lastSync1.value || lastSync2.value) && !unref(isAccountSyncing) ? (openBlock(), createElementBlock("span", _hoisted_21, " ago")) : createCommentVNode("", true)
                ])) : createCommentVNode("", true)
              ])) : createCommentVNode("", true)
            ], 32),
            _cache[10] || (_cache[10] = createBaseVNode("div", { class: "cc-none xxxs:block grow w-px" }, null, -1)),
            unref(appAccount) && unref(isNormalMode)() ? (openBlock(), createElementBlock("div", {
              key: 0,
              class: "flex-none flex w-12 sm:w-14 h-12 sm:h-14 flex-row flex-nowrap justify-center items-center cc-area-light-1 px-3 py-3 sm:px-4 sm:py-4 cursor-pointer cc-btn-tertiary-light",
              onClick: withModifiers(onSetDAppAccount, ["stop", "prevent"])
            }, [
              unref(appAccount).isDappAccount ? (openBlock(), createElementBlock("svg", _hoisted_22, _cache[7] || (_cache[7] = [
                createBaseVNode("path", { d: "M 20.59375 2 L 17.09375 5.5 L 15.1875 3.59375 C 14.3875 2.79375 13.20625 2.79375 12.40625 3.59375 L 9.90625 6.09375\nL 8.90625 5.09375 L 7.5 6.5 L 17.5 16.5 L 18.90625 15.09375 L 17.90625 14.09375\nL 20.40625 11.59375 C 21.20625 10.79375 21.20625 9.6125 20.40625 8.8125 L 18.5 6.90625\nL 22 3.40625 L 20.59375 2 z M 6.40625 7.59375 L 5 9 L 6 10 L 3.59375 12.40625 C 2.79375 13.20625 2.79375 14.3875 3.59375 15.1875\nL 5.5 17.09375 L 2 20.59375 L 3.40625 22 L 6.90625 18.5 L 8.8125 20.40625 C 9.6125 21.20625 10.79375 21.20625 11.59375 20.40625\nL 14 18 L 15 19 L 16.40625 17.59375 L 6.40625 7.59375 z" }, null, -1)
              ]))) : (openBlock(), createElementBlock("svg", _hoisted_23, _cache[8] || (_cache[8] = [
                createBaseVNode("path", { d: "M 14.8125 2 C 14.3125 2 13.80625 2.19375 13.40625 2.59375 L 11.90625 4.09375 L 10.90625 3.09375 L 9.5 4.5\nL 11.8125 6.8125 L 9.1875 9.40625 L 10.59375 10.8125 L 13.1875 8.1875 L 15.8125 10.8125 L 13.1875 13.40625\nL 14.59375 14.8125 L 17.1875 12.1875 L 19.5 14.5 L 20.90625 13.09375 L 19.90625 12.09375 L 21.40625 10.59375\nC 22.20625 9.79375 22.20625 8.6125 21.40625 7.8125 L 19.5 5.90625 L 22 3.40625 L 20.59375 2 L 18.09375 4.5\nL 16.1875 2.59375 C 15.7875 2.19375 15.3125 2 14.8125 2 z M 4.40625 9.59375 L 3 11 L 4 12 L 2.59375 13.40625\nC 1.79375 14.20625 1.79375 15.3875 2.59375 16.1875 L 4.5 18.09375 L 2 20.59375 L 3.40625 22 L 5.90625 19.5\nL 7.8125 21.40625 C 8.6125 22.20625 9.79375 22.20625 10.59375 21.40625 L 12 20 L 13 21 L 14.40625 19.59375 L 4.40625 9.59375 z" }, null, -1)
              ])))
            ])) : createCommentVNode("", true),
            createBaseVNode("div", {
              class: "flex-none cc-none xs:flex w-auto min-w-[6rem] h-12 sm:h-14 flex-row flex-nowrap justify-start items-start cc-area-light-1 px-2 py-2 cursor-pointer cc-btn-tertiary-light",
              onClick: withModifiers(gotoAccountList, ["stop", "prevent"])
            }, [
              unref(appAccount) ? (openBlock(), createElementBlock("div", _hoisted_24, [
                createBaseVNode("div", _hoisted_25, [
                  unref(isAccountSyncing) ? (openBlock(), createElementBlock("div", _hoisted_26, [
                    createVNode(QSpinnerDots_default, {
                      color: "gray",
                      size: "1rem"
                    })
                  ])) : createCommentVNode("", true),
                  unref(appAccount).isDappAccount ? (openBlock(), createElementBlock("i", _hoisted_27)) : createCommentVNode("", true),
                  createTextVNode(" " + toDisplayString(unref(accountName)), 1)
                ]),
                unref(accountBalance) ? (openBlock(), createBlock(_sfc_main$b, {
                  key: 0,
                  balance: unref(accountBalance),
                  syncInfo: unref(appAccount).syncInfo,
                  field: "total",
                  syncing: unref(isAccountSyncing),
                  "hide-sync-button": "",
                  "icons-left": ""
                }, null, 8, ["balance", "syncInfo", "syncing"])) : createCommentVNode("", true)
              ])) : createCommentVNode("", true)
            ]),
            unref(networkId) === "mainnet" && unref(isNormalMode)() && !unref(isIosApp)() ? (openBlock(), createElementBlock("div", {
              key: 1,
              class: "cc-none xxxs:flex flex-none w-12 sm:w-14 h-12 sm:h-14 flex-row flex-nowrap justify-center items-center cc-area-light-1 px-3 py-3 sm:px-4 sm:py-4 cursor-pointer cc-btn-tertiary-light",
              onClick: withModifiers(onOpenOnOffRampModal, ["stop", "prevent"])
            }, [
              _cache[9] || (_cache[9] = createBaseVNode("div", { class: "flex flex-col space-y-1 justify-center items-center font-bold" }, [
                createBaseVNode("span", null, "Buy"),
                createBaseVNode("span", null, "ADA")
              ], -1)),
              createVNode(_sfc_main$3, {
                "show-on-off-ramp-modal": showOnOffRampModal.value,
                onClose: _cache[3] || (_cache[3] = ($event) => showOnOffRampModal.value = false)
              }, null, 8, ["show-on-off-ramp-modal"])
            ])) : createCommentVNode("", true)
          ])
        ]),
        !unref(isSignMode)() ? (openBlock(), createElementBlock("div", _hoisted_28, [
          createBaseVNode("nav", _hoisted_29, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(options.value, (item, index) => {
              return openBlock(), createBlock(_sfc_main$2, {
                key: index,
                label: item.label,
                "label-short": item.labelShort,
                "label-c-s-s": item.labelCSS,
                icon: item.icon,
                "icon-c-s-s": "text-xl " + (item.iconCSS ?? ""),
                "border-c-s-s": item.borderCSS ?? "",
                "border-active-c-s-s": item.borderActiveCSS ?? "",
                link: void 0,
                active: item.link === unref(route).name,
                onClicked: ($event) => item.func ? item.func() : unref(gotoWalletPage)(item.link)
              }, null, 8, ["label", "label-short", "label-c-s-s", "icon", "icon-c-s-s", "border-c-s-s", "border-active-c-s-s", "active", "onClicked"]);
            }), 128))
          ])
        ])) : createCommentVNode("", true),
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 1,
          "half-wide": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_30, [
              createBaseVNode("div", _hoisted_31, [
                createVNode(_sfc_main$5, {
                  label: unref(it)("wallet.settings.modal.headline"),
                  "do-capitalize": ""
                }, null, 8, ["label"]),
                createVNode(_sfc_main$7, {
                  text: unref(it)("wallet.settings.modal.caption")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_32, [
              createVNode(_sfc_main$c, {
                class: "mt-0",
                "open-setting": openSetting.value
              }, null, 8, ["open-setting"]),
              createVNode(_sfc_main$d, { class: "mt-8" }),
              createVNode(_sfc_main$e, { class: "mt-8" })
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const WalletHeader = /* @__PURE__ */ _export_sfc(_sfc_main$1, [["__scopeId", "data-v-ff119fcb"]]);
const _hoisted_1 = {
  key: 1,
  class: "col-span-12 pt-18 sm:pt-36 relative flex-1 flex justify-center items-center"
};
const _hoisted_2 = { class: "flex flex-col flex-nowrap justify-center items-center" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Wallet",
  setup(__props) {
    const {
      hasSelectedWallet,
      hasSelectedAccount
    } = useSelectedAccount();
    return (_ctx, _cache) => {
      const _component_router_view = resolveComponent("router-view");
      return openBlock(), createBlock(_sfc_main$f, {
        containerCSS: "",
        "align-top": "",
        "add-scroll": true
      }, {
        header: withCtx(() => [
          unref(hasSelectedWallet) && unref(hasSelectedAccount) ? (openBlock(), createBlock(WalletHeader, { key: 0 })) : createCommentVNode("", true)
        ]),
        default: withCtx(() => [
          unref(hasSelectedWallet) && unref(hasSelectedAccount) ? (openBlock(), createBlock(_component_router_view, { key: 0 })) : (openBlock(), createElementBlock("div", _hoisted_1, [
            createBaseVNode("div", _hoisted_2, [
              createVNode(QSpinnerDots_default, {
                color: "gray",
                size: "3em"
              })
            ])
          ]))
        ]),
        _: 1
      });
    };
  }
});
const Wallet = /* @__PURE__ */ _export_sfc(_sfc_main, [["__scopeId", "data-v-2ed93f69"]]);
export {
  Wallet as default
};
