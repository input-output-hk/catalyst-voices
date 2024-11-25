import { d as defineComponent, a7 as useQuasar, f as computed, er as MAX_ACCOUNTS, z as ref, dd as isHDAccount, D as watch, a8 as SyncState, bI as onBeforeMount, C as onMounted, aW as addSignalListener, hy as onAccountDataUpdated, aG as onUnmounted, aX as removeSignalListener, o as openBlock, c as createElementBlock, a as createBlock, j as createCommentVNode, q as createVNode, u as unref, h as withCtx, e as createBaseVNode, H as Fragment, I as renderList, b as withModifiers, n as normalizeClass, t as toDisplayString, F as withDirectives, ab as withKeys, ge as vModelText, aA as renderSlot, cf as getRandomId, ae as useSelectedAccount, V as nextTick, ks as verifyRootKeyPassword, kt as createAdditionalAccountMnemonic, ku as createAdditionalAccountsHardwareWallet, kv as saveWallet, bm as dispatchSignal, kw as onReloadWalletList, kx as doRemoveAccount, aP as sleep, bT as json, dc as purpose, a6 as useAppWallet, e7 as useAppAccount, a5 as toRefs, kr as onPoolDataUpdated, ky as poolDataList, k as dispatchSignalSync, da as doToggleDappAccountId, kz as onAccountRemoved } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { a as useTrezorDevice, u as useLedgerDevice } from "./useTrezorDevice.js";
import { _ as _sfc_main$4, u as useKeystoneDevice } from "./Keystone.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$6, a as _sfc_main$7 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$5 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { I as IconInfo } from "./IconInfo.js";
import { I as IconError } from "./IconError.js";
import { _ as _sfc_main$8 } from "./GridFormSignWithPassword.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$9 } from "./LedgerTransport.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$d } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$b } from "./AccountItemBalance.vue_vue_type_script_setup_true_lang.js";
import { u as updatePoolInRewardInfo } from "./reward.js";
import { _ as _sfc_main$a } from "./GridStakePoolList.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$c } from "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$e } from "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useTabId.js";
import "./browser.js";
import "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./_plugin-vue_export-helper.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import "./GridInput.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import "./useAdaSymbol.js";
import "./InlineButton.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1$3 = { class: "grid grid-cols-12 cc-gap" };
const _hoisted_2$1 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_3$1 = { class: "flex flex-col cc-text-sz" };
const _hoisted_4$1 = {
  key: 0,
  class: "col-span-12 flex flex-row flex-nowrap whitespace-pre-wrap p-4"
};
const _hoisted_5 = { class: "w-full py-0 grid grid-cols-3 lg:grid-cols-4 gap-1.5 xs:gap-2" };
const _hoisted_6 = ["onClick"];
const _hoisted_7 = {
  key: 0,
  class: "w-full border-2 absolute top-[99%] z-20 h-8 flex box-border left-0 z-max cc-text-bold cursor-pointer rounded-t-none box-shadow"
};
const _hoisted_8 = { class: "flex flex-nowrap clear-both cc-bg-light-0 z-max w-full divide-x grid grid-cols-2 box-content" };
const _hoisted_9 = ["onClick"];
const _hoisted_10 = {
  key: 0,
  class: "mdi mdi-check cursor-pointer mx-1 z-max"
};
const _hoisted_11 = ["onClick"];
const _hoisted_12 = {
  key: 0,
  class: "mdi mdi-close cursor-pointer mx-1"
};
const _hoisted_13 = { class: "w-full flex flex-nowrap items-center justify-center min-h-10" };
const _hoisted_14 = {
  key: 0,
  class: "grow pl-6 text-center flex-1 flex items-center justify-start align-middle justify-center tracking-normal"
};
const _hoisted_15 = ["onKeydown", "onUpdate:modelValue", "on:lostFocus", "min"];
const _hoisted_16 = { class: "flex grow-0 flex-1 items-center justify-start align-middle justify-center" };
const _hoisted_17 = ["onClick"];
const _hoisted_18 = ["onClick"];
const _hoisted_19 = {
  key: 2,
  class: "mdi mdi-close-circle-outline w-4 mr-2 opacity-0"
};
const _hoisted_20 = { class: "grid grid-cols-12 cc-gap p-4 w-full" };
const _hoisted_21 = {
  key: 1,
  class: "col-span-12"
};
const _hoisted_22 = {
  key: 2,
  class: "col-span-12 grid grid-cols-12 cc-gap mb-2 lg:mb-0"
};
const _hoisted_23 = { class: "col-span-12 flex flex-row flex-nowrap items-center whitespace-pre-wrap cc-text-sz" };
const maxAccountIndex = 1e4;
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "SignAddAccount",
  props: {
    textId: { type: String, required: true },
    type: { type: String, required: false, default: "" },
    showLabel: { type: Boolean, required: false, default: true }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const storeId = "SignAddAccount" + getRandomId();
    const { t } = useTranslation();
    const {
      initiateTrezor,
      getTrezorPublicKey,
      getTrezorDerivationTypeFromWalletId
    } = useTrezorDevice();
    const {
      getLedgerPublicKey
    } = useLedgerDevice();
    const {
      getKeystonePublicKeyUR,
      handleMultiAccountScan
    } = useKeystoneDevice();
    const $q = useQuasar();
    const {
      appWallet,
      walletData,
      accountData
    } = useSelectedAccount();
    const accountLimitReached = computed(() => {
      var _a;
      return (((_a = appWallet.value) == null ? void 0 : _a.data.wallet.accountList.length) ?? 1) > MAX_ACCOUNTS;
    });
    const signError = ref("");
    const showDialog = ref(false);
    const isMnemonic = computed(() => {
      var _a;
      return ((_a = appWallet.value) == null ? void 0 : _a.isMnemonic) ?? false;
    });
    const isLedger = computed(() => {
      var _a;
      return ((_a = appWallet.value) == null ? void 0 : _a.isLedger) ?? false;
    });
    const isTrezor = computed(() => {
      var _a;
      return ((_a = appWallet.value) == null ? void 0 : _a.isTrezor) ?? false;
    });
    const isKeystone = computed(() => {
      var _a;
      return ((_a = appWallet.value) == null ? void 0 : _a.isKeystone) ?? false;
    });
    const isHW = computed(() => isLedger.value || isTrezor.value || isKeystone.value);
    const keystoneUR = ref();
    const minAccountIndex = ref(null);
    const discoveryCurList = ref([]);
    const discoveryList = ref([]);
    const discoveryRemoveList = ref([]);
    const discoveryTotal = ref(0);
    const discoverCount = ref(0);
    const accountsToAdd = ref([]);
    const accountsToRemove = ref([]);
    const resetInput = () => {
      accountsToRemove.value = [];
      accountsToAdd.value = [];
      discoverCount.value = 0;
    };
    const indexToAdd = computed(() => {
      var _a;
      let activeIndexes = ((_a = appWallet.value) == null ? void 0 : _a.data.wallet.accountList.filter((account) => isHDAccount(account.path)).map((value) => value.path[2])) ?? [];
      return [...Array(MAX_ACCOUNTS).keys()].filter((index) => !activeIndexes.includes(index));
    });
    const accountSlots = ref([...Array(MAX_ACCOUNTS).keys()]);
    const slotAccountMap = ref([]);
    const slotEditMap = ref([...Array(MAX_ACCOUNTS).fill(false)]);
    const slotEditValueMap = ref([]);
    const slotEditErrorMap = ref([...Array(MAX_ACCOUNTS).fill("")]);
    const slotInputFields = ref([]);
    const restSlotMap = () => {
      accountSlots.value = [...Array(MAX_ACCOUNTS).keys()];
      slotAccountMap.value = [];
      slotEditMap.value = [...Array(MAX_ACCOUNTS).fill(false)];
      slotEditValueMap.value = [];
      slotEditErrorMap.value = [...Array(MAX_ACCOUNTS).fill("")];
    };
    const inputMapContainsError = computed(() => slotEditErrorMap.value.some((error, index) => error !== ""));
    const buildAccountIndexSlotMap = () => {
      var _a;
      restSlotMap();
      const accountsUsed = ((_a = appWallet.value) == null ? void 0 : _a.data.wallet.accountList.filter((account) => isHDAccount(account.path)).reduceRight((indexList, currentAccount) => {
        return indexList.concat([currentAccount.path[2]]);
      }, []).sort((indexA, indexB) => indexA > indexB ? 1 : -1)) ?? [];
      const highestAccountNumber = Math.max(...accountsUsed);
      let fillAscending = true;
      if (accountsUsed.length <= MAX_ACCOUNTS && highestAccountNumber > MAX_ACCOUNTS - 1) {
        fillAscending = false;
      }
      while (slotAccountMap.value.length <= MAX_ACCOUNTS - 1) {
        const slotIndexToFill = slotAccountMap.value.length;
        if (fillAscending) {
          slotAccountMap.value.push(slotIndexToFill);
        } else {
          const accountIndexToAdd = accountsUsed.find((accountIndex) => !slotAccountMap.value.includes(accountIndex));
          if (accountIndexToAdd !== void 0) {
            slotAccountMap.value.push(accountIndexToAdd);
          } else {
            let indexToAdd2 = 0;
            while (slotAccountMap.value.includes(indexToAdd2)) {
              indexToAdd2++;
            }
            if (minAccountIndex.value === null) {
              minAccountIndex.value = indexToAdd2;
            }
            slotAccountMap.value.push(indexToAdd2);
          }
        }
      }
      slotAccountMap.value.forEach((accountIndex, slotIndex) => slotEditValueMap.value[slotIndex] = String(accountIndex));
    };
    const editSlot = (event, slotNumber) => {
      event.stopPropagation();
      slotEditMap.value[slotNumber] = true;
      nextTick(() => {
        slotInputFields.value[slotNumber].focus();
      });
    };
    const onResetIndexAdd = (index, e) => {
      e.stopPropagation();
      slotEditMap.value[index] = false;
      slotEditValueMap.value[index] = String(slotAccountMap.value[index]);
      addToSelection(e, index, false, true);
      clearErrorForInput(index);
      updateErrorMessage();
    };
    const validateIndexToAdd = (index, item) => {
      submitIndexAdd(null, index, item);
    };
    const submitIndexAdd = (event, index, item) => {
      if (check(index)) {
        slotEditMap.value[index] = false;
        addToSelection(event, item, true);
      } else {
        event == null ? void 0 : event.stopPropagation();
        slotInputFields.value[index].focus();
      }
    };
    const check = (index) => {
      var _a;
      signError.value = "";
      if (slotEditValueMap.value[index].length === 0 || Number.isNaN(slotEditValueMap.value[index])) {
        addSlotError(index, t(props.textId + ".error.noNumber"));
        return false;
      }
      if (Number(slotEditValueMap.value[index]) > maxAccountIndex) {
        addSlotError(index, t(props.textId + ".error.maxAccount").replace("###MAX###", String(maxAccountIndex)));
        return false;
      }
      signError.value = "";
      const accountToAdd = Number(slotEditValueMap.value[index]);
      const accountIndexUsed = ((_a = appWallet.value) == null ? void 0 : _a.data.wallet.accountList.filter((account) => isHDAccount(account.path)).find((account) => account.path[2] === accountToAdd)) ?? void 0;
      if (accountIndexUsed) {
        const indexUsed = slotAccountMap.value.indexOf(accountToAdd);
        if (indexUsed !== -1) {
          addSlotError(index, t(props.textId + ".error.inUse").replace("###INDEX###", String(accountToAdd)).replace("###SLOT###", String(indexUsed + 1)));
          return false;
        }
      }
      const indexUsedInEdit = slotEditValueMap.value.find((value, editIndex) => Number(value) === accountToAdd && editIndex !== index);
      if (indexUsedInEdit !== void 0) {
        addSlotError(index, t(props.textId + ".error.enable").replace("###INDEX###", String(accountToAdd)).replace("###SLOT###", String(Number(indexUsedInEdit) + 1)));
        return false;
      }
      clearErrorForInput(index);
      return true;
    };
    const addSlotError = (index, error) => {
      slotEditErrorMap.value[index] = error;
      updateErrorMessage();
    };
    const updateErrorMessage = () => {
      if (!inputMapContainsError.value) {
        signError.value = "";
      } else {
        signError.value = "Slot errors: \n" + slotEditErrorMap.value.reduceRight((text, entry) => entry != "" ? text = entry + "\n" + text : text, "");
      }
    };
    const clearErrorForInput = (index) => {
      slotEditErrorMap.value[index] = "";
    };
    const activeAccountIndexes = computed(
      () => {
        var _a;
        return ((_a = appWallet.value) == null ? void 0 : _a.data.wallet.accountList.filter((account) => isHDAccount(account.path)).map((value) => value.path[2])) ?? [];
      }
    );
    const isActive = (index) => {
      return accountData.value.account.path[2] === index;
    };
    const canBeAdded = (index) => {
      if (!isActive(Number(slotEditValueMap.value[index])) && !accountsToAdd.value.includes(index)) {
        return true;
      }
      if (accountsToRemove.value.includes(Number(slotEditValueMap.value[index]))) {
        return true;
      }
      if (accountsToRemove.value.includes(index)) {
        return true;
      }
      if (slotEditMap.value[index]) {
        return false;
      }
      return false;
    };
    const canBeRemoved = (index) => !isActive(index);
    const addToSelection = (event, index, force = false, forceRemoval = false) => {
      event == null ? void 0 : event.stopPropagation();
      if (!forceRemoval && (canBeAdded(index) || force)) {
        if (accountsToRemove.value.includes(Number(slotEditValueMap.value[index]))) {
          accountsToRemove.value.splice(accountsToRemove.value.indexOf(Number(slotEditValueMap.value[index])), 1);
        }
        accountsToAdd.value.push(index);
      } else {
        if (accountsToAdd.value.includes(index)) {
          accountsToAdd.value.splice(accountsToAdd.value.indexOf(index), 1);
        }
      }
      updateErrorMessage();
    };
    const addToRemoveList = (event, index) => {
      event.stopPropagation();
      if (canBeRemoved(slotAccountMap.value[index])) {
        if (accountsToAdd.value.includes(slotAccountMap.value[index])) {
          accountsToAdd.value.splice(accountsToAdd.value.indexOf(slotAccountMap.value[index]), 1);
        }
        accountsToRemove.value.push(slotAccountMap.value[index]);
      }
    };
    const discoverDialog = ref(false);
    const openDiscoverDialog = () => openDialog(true);
    const openDialog = (discover = false) => {
      buildAccountIndexSlotMap();
      discoverDialog.value = discover;
      showDialog.value = true;
    };
    const removeAccounts = async () => {
      var _a, _b;
      const walletId = (_a = appWallet.value) == null ? void 0 : _a.data.wallet.id;
      const _accountList = ((_b = appWallet.value) == null ? void 0 : _b.data.wallet.accountList.filter((account) => isHDAccount(account.path))) ?? [];
      for (let i = _accountList.length - 1; i >= 0; i--) {
        if (accountsToRemove.value.includes(_accountList[i].path[2])) {
          await dispatchSignal(doRemoveAccount, walletId, _accountList[i].id);
        }
      }
    };
    const getHWPubKeyMap = async (accIdxToAddList) => {
      if (!walletData.value || !accountData.value) {
        return null;
      }
      let accountsPubBech32Map = null;
      const signType = walletData.value.wallet.signType;
      if (signType === "ledger" || signType === "trezor" || signType === "keystone") {
        let pubKeyList;
        accIdxToAddList.unshift(accountData.value.account.path[2]);
        console.log("accIdxToAddList", accIdxToAddList);
        if (signType === "ledger" || signType === "trezor") {
          $q.loading.show({
            boxClass: "cc-bg-overlay",
            message: t(props.textId + ".loading." + signType) + (discoverDialog.value && isLedger.value ? t(props.textId + ".loading.ledgerdiscover") : ""),
            html: true
          });
        }
        try {
          if (isLedger.value) {
            pubKeyList = await getLedgerPublicKey(purpose.hdwallet, 0, 0, accIdxToAddList);
          } else if (isTrezor.value) {
            const features = await initiateTrezor();
            pubKeyList = await getTrezorPublicKey(purpose.hdwallet, 0, 0, accIdxToAddList, getTrezorDerivationTypeFromWalletId(walletData.value.wallet.id));
          } else if (isKeystone.value) {
            const publicKeyUR = getKeystonePublicKeyUR(purpose.hdwallet, 0, 0, accIdxToAddList);
            const signResult = await signWithKeystone(publicKeyUR);
            if (signResult.error) {
              throw Error(signResult.error);
            }
            pubKeyList = signResult.pubKeyList;
          }
        } catch (err) {
          signError.value = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
          $q.loading.hide();
          return null;
        }
        $q.loading.hide();
        if (pubKeyList.length === 0 && accountsToRemove.value.length === 0) {
          signError.value = t(props.textId + ".error.nokey");
          return null;
        } else if (accountData.value.account.pub !== pubKeyList[0] || pubKeyList.length !== accIdxToAddList.length) {
          signError.value = t(props.textId + ".error.mismatch");
          return null;
        }
        accountsPubBech32Map = {};
        for (let i = 0; i < pubKeyList.length; i++) {
          accountsPubBech32Map[pubKeyList[i]] = accIdxToAddList[i];
        }
      }
      console.log("accountsPubBech32Map", json(accountsPubBech32Map));
      return accountsPubBech32Map;
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
          message: t("wallet.keystone.ok"),
          position: "top-left"
        });
        if (keystoneSignResolve) {
          keystoneSignResolve(handleMultiAccountScan(data.type, data.cbor));
        }
      } catch (err) {
        if (keystoneSignResolve) {
          keystoneSignResolve({ error: (err == null ? void 0 : err.message) ?? JSON.stringify(err) });
        }
      }
      keystoneUR.value = void 0;
    }
    async function onGenerateAccounts(payload) {
      signError.value = "";
      const _appWallet = appWallet.value;
      if (!_appWallet) {
        return;
      }
      if (!walletData.value || !accountData.value) {
        return;
      }
      if (discoverDialog.value) {
        await discoverAccount(payload == null ? void 0 : payload.password);
        return;
      }
      const signType = walletData.value.wallet.signType;
      if (signType === "readonly") {
        return;
      }
      if (signType === "mnemonic" && (payload == null ? void 0 : payload.password) && !verifyRootKeyPassword(walletData.value, payload.password)) {
        signError.value = t(props.textId + ".error.password");
        return;
      }
      let accountCreationSuccess = true;
      if (accountsToRemove.value.length > 0) {
        await removeAccounts();
      }
      const accIdxToAddList = [];
      for (let i = 0; i < accountsToAdd.value.length; i++) {
        accIdxToAddList.push(Number(slotEditValueMap.value[accountsToAdd.value[i]]));
      }
      if (accIdxToAddList.length > 0) {
        let accountsPubBech32Map = {};
        if (signType !== "mnemonic") {
          accountsPubBech32Map = await getHWPubKeyMap(accIdxToAddList);
        }
        const { createdAccountIndexList } = signType === "mnemonic" ? createAdditionalAccountMnemonic(_appWallet.data, payload.password, accIdxToAddList) : createAdditionalAccountsHardwareWallet(_appWallet.data, accountsPubBech32Map);
        if (signError.value.length > 0) {
          return;
        }
        const success = await saveWallet(_appWallet);
        accountCreationSuccess = success && createdAccountIndexList.length === (signType === "mnemonic" ? accIdxToAddList.length : accIdxToAddList.length - 1);
      }
      if (!accountCreationSuccess) {
        signError.value = t(props.textId + ".error.general");
      } else {
        await dispatchSignal(onReloadWalletList);
        buildAccountIndexSlotMap();
        closeDialog();
        resetInput();
        $q.notify({
          type: "positive",
          message: "Account(s) updated.",
          position: "top-left",
          timeout: 3e3
        });
      }
    }
    const onAccountSynced = async (appAccount) => {
      const isWantedAccount = discoveryList.value.some((account) => account.id === appAccount.id);
      if (!isWantedAccount) {
        return;
      }
      const hasUsedCreds = appAccount.data.keys.payment.some((payment) => payment.used);
      if (!hasUsedCreds) {
        discoveryRemoveList.value.push(appAccount.id);
      }
      const index = discoveryList.value.findIndex((account) => account.id === appAccount.id);
      if (index !== -1) {
        discoveryList.value.splice(index, 1);
      }
      discoverCount.value = discoveryTotal.value - discoveryList.value.length;
      updateOverlayMessage();
      if (discoveryList.value.length === 0) {
        if (appWallet.value) {
          for (let i = discoveryRemoveList.value.length - 1; i >= 0; i--) {
            await dispatchSignal(doRemoveAccount, appAccount.walletId, discoveryRemoveList.value[i], i === 0);
            discoveryRemoveList.value.splice(i, 1);
            await sleep(100);
          }
          await dispatchSignal(onReloadWalletList);
        }
        $q.loading.hide();
      }
    };
    watch(appWallet, () => {
      if (appWallet.value && appWallet.value.syncInfo.state === SyncState.success) {
        $q.loading.hide();
      }
    });
    const discoverAccount = async (password) => {
      const _appWallet = appWallet.value;
      if (!_appWallet) {
        return;
      }
      signError.value = "";
      discoverDialog.value = true;
      accountsToRemove.value.splice(0);
      const signType = _appWallet.data.wallet.signType;
      if (signType === "readonly") {
        return;
      }
      if (signType === "mnemonic" && password && !verifyRootKeyPassword(_appWallet.data, password)) {
        signError.value = t(props.textId + ".error.password");
        return;
      }
      const currentAccountList = _appWallet.data.wallet.accountList.filter((account) => isHDAccount(account.path));
      const accIdxToDiscoverList = [];
      for (let i = 0; i < MAX_ACCOUNTS; i++) {
        if (!currentAccountList.some((a) => a.path[2] === i)) {
          accIdxToDiscoverList.push(i);
        }
      }
      let accountsPubBech32Map = {};
      if (signType !== "mnemonic") {
        accountsPubBech32Map = await getHWPubKeyMap(accIdxToDiscoverList);
      }
      const { createdAccountIndexList } = signType === "mnemonic" ? createAdditionalAccountMnemonic(_appWallet.data, password, accIdxToDiscoverList) : createAdditionalAccountsHardwareWallet(_appWallet.data, accountsPubBech32Map);
      if (signError.value.length > 0) {
        return;
      }
      if (createdAccountIndexList.length > 0) {
        discoveryCurList.value = currentAccountList;
        discoveryList.value = _appWallet.data.wallet.accountList.filter((account) => createdAccountIndexList.includes(account.path[2]));
        discoveryTotal.value = discoveryList.value.length;
        discoveryRemoveList.value = [];
        discoverCount.value = 0;
        console.warn("discoveryCurList.value", json(discoveryCurList.value));
        console.warn("discoveryList.value", json(discoveryList.value));
        console.warn("discoveryTotal.value", json(discoveryTotal.value));
        updateOverlayMessage();
        closeDialog();
        await saveWallet(_appWallet);
        await dispatchSignal(onReloadWalletList);
      }
    };
    let hideOverlayMessageToid = -1;
    const updateOverlayMessage = () => {
      clearTimeout(hideOverlayMessageToid);
      $q.loading.show({
        boxClass: "cc-bg-overlay",
        message: t(props.textId + ".loading.discover").replace("###syncing###", discoverCount.value.toString()).replace("###total###", discoveryTotal.value.toString())
      });
      hideOverlayMessageToid = setTimeout(hideOverlayMessage, 6e4);
    };
    const hideOverlayMessage = () => {
      $q.loading.hide();
    };
    function closeDialog() {
      showDialog.value = false;
      slotEditMap.value.forEach((editFlag, editIndex) => {
        slotEditMap.value[editIndex] = false;
        clearErrorForInput(editIndex);
      });
      updateErrorMessage();
      resetInput();
    }
    const setItemRef = (el, index) => {
      if (el && !slotInputFields.value[index]) {
        slotInputFields.value[index] = el;
      }
    };
    onBeforeMount(() => {
      buildAccountIndexSlotMap();
    });
    onMounted(() => {
      addSignalListener(onAccountDataUpdated, storeId, onAccountSynced);
    });
    onUnmounted(() => {
      removeSignalListener(onAccountDataUpdated, storeId);
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$3, [
        isKeystone.value ? (openBlock(), createBlock(_sfc_main$4, {
          key: 0,
          open: !!keystoneUR.value,
          "keystone-u-r": keystoneUR.value,
          onClose: onKeystoneClose,
          onDecode: onKeystoneScan
        }, null, 8, ["open", "keystone-u-r"])) : createCommentVNode("", true),
        createVNode(_sfc_main$5, {
          class: "col-start-0 col-span-6 sm:col-start-10 sm:col-span-3",
          label: unref(t)(__props.textId + ".button.manage"),
          link: openDialog
        }, null, 8, ["label"]),
        !accountLimitReached.value ? (openBlock(), createBlock(_sfc_main$5, {
          key: 1,
          class: "col-start-7 col-span-6 sm:col-start-10 sm:col-span-3",
          label: unref(t)(__props.textId + ".button.discover"),
          link: openDiscoverDialog
        }, null, 8, ["label"])) : createCommentVNode("", true),
        showDialog.value ? (openBlock(), createBlock(Modal, {
          key: 2,
          narrow: "",
          "full-width-on-mobile": "",
          onClose: closeDialog
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_2$1, [
              createBaseVNode("div", _hoisted_3$1, [
                createVNode(_sfc_main$6, {
                  label: discoverDialog.value ? unref(t)("wallet.create.account.discover.title") : unref(t)(__props.textId + ".button.add")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$7, {
                  text: discoverDialog.value ? unref(t)("wallet.create.account.discover.caption").replace("####accountLimit####", unref(MAX_ACCOUNTS).toString()) : unref(t)("wallet.summary.accounts.add.caption")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            !discoverDialog.value ? (openBlock(), createElementBlock("div", _hoisted_4$1, [
              createBaseVNode("div", _hoisted_5, [
                (openBlock(true), createElementBlock(Fragment, null, renderList(accountSlots.value, (item, index) => {
                  var _a;
                  return openBlock(), createElementBlock("div", {
                    key: index,
                    onClick: withModifiers(($event) => addToSelection($event, item), ["stop"]),
                    class: normalizeClass(["relative noselect cc-area-light cc-text-bold cursor-pointer cc-text-sz h-10 min-h-10 -z-1", "  " + (slotAccountMap.value[index] === unref(accountData).account.path[2] ? "cc-btn-disabled" : "") + "  " + ((accountsToAdd.value.includes(index) || activeAccountIndexes.value.includes(slotAccountMap.value[index])) && !accountsToRemove.value.includes(slotAccountMap.value[index]) ? " ring-2 cc-ring-highlight " : " ")])
                  }, [
                    slotEditMap.value[index] ? (openBlock(), createElementBlock("div", _hoisted_7, [
                      createBaseVNode("div", _hoisted_8, [
                        createBaseVNode("div", {
                          class: "flex w-full items-center justify-evenly",
                          onClick: ($event) => {
                            submitIndexAdd($event, index, item);
                          }
                        }, [
                          slotEditMap.value[index] ? (openBlock(), createElementBlock("i", _hoisted_10)) : createCommentVNode("", true)
                        ], 8, _hoisted_9),
                        createBaseVNode("div", {
                          class: "flex w-full items-center justify-evenly",
                          onClick: ($event) => onResetIndexAdd(index, $event)
                        }, [
                          slotEditMap.value[index] ? (openBlock(), createElementBlock("i", _hoisted_12)) : createCommentVNode("", true)
                        ], 8, _hoisted_11)
                      ])
                    ])) : createCommentVNode("", true),
                    createBaseVNode("div", _hoisted_13, [
                      !slotEditMap.value[index] ? (openBlock(), createElementBlock("span", _hoisted_14, toDisplayString(slotEditValueMap.value[index]), 1)) : createCommentVNode("", true),
                      slotEditMap.value[index] ? withDirectives((openBlock(), createElementBlock("input", {
                        key: 1,
                        onKeydown: [
                          withKeys(($event) => {
                            submitIndexAdd($event, index, item);
                          }, ["enter"]),
                          withKeys(($event) => onResetIndexAdd(index, $event), ["esc"])
                        ],
                        type: "number",
                        "onUpdate:modelValue": ($event) => slotEditValueMap.value[index] = $event,
                        onClick: _cache[0] || (_cache[0] = withModifiers((event) => event.stopPropagation(), ["stop"])),
                        "on:lostFocus": ($event) => validateIndexToAdd(index, item),
                        ref_for: true,
                        ref: (event) => setItemRef(event, index),
                        min: minAccountIndex.value ?? void 0,
                        max: maxAccountIndex,
                        class: "w-full border-2 cc-bg-light-0 border-0 cc-text-color pointer-cursor rounded-t-md text-left"
                      }, null, 40, _hoisted_15)), [
                        [vModelText, slotEditValueMap.value[index]]
                      ]) : createCommentVNode("", true),
                      createBaseVNode("div", _hoisted_16, [
                        !activeAccountIndexes.value.includes(slotAccountMap.value[index]) && !accountsToRemove.value.includes(slotAccountMap.value[index]) && !slotEditMap.value[index] ? (openBlock(), createElementBlock("i", {
                          key: 0,
                          class: "mdi mdi-pencil cursor-pointer w-4 mr-2",
                          onClick: ($event) => editSlot($event, index)
                        }, null, 8, _hoisted_17)) : activeAccountIndexes.value.includes(slotAccountMap.value[index]) && !indexToAdd.value.includes(slotAccountMap.value[index]) && ((_a = unref(accountData)) == null ? void 0 : _a.account.path[2]) !== index && !accountsToRemove.value.includes(slotAccountMap.value[index]) ? (openBlock(), createElementBlock("i", {
                          key: 1,
                          class: "text-2xl mdi mdi-close-circle-outline w-4 mr-4 cursor-pointer",
                          onClick: ($event) => addToRemoveList($event, index)
                        }, null, 8, _hoisted_18)) : !slotEditMap.value[index] ? (openBlock(), createElementBlock("i", _hoisted_19)) : createCommentVNode("", true)
                      ])
                    ])
                  ], 10, _hoisted_6);
                }), 128))
              ])
            ])) : createCommentVNode("", true)
          ]),
          footer: withCtx(() => {
            var _a;
            return [
              createBaseVNode("div", _hoisted_20, [
                isMnemonic.value ? (openBlock(), createBlock(_sfc_main$8, {
                  key: 0,
                  class: "col-span-12",
                  autocomplete: "off",
                  "submit-enable": !inputMapContainsError.value,
                  "submit-label": discoverDialog.value ? "common.label.discover" : "common.label.sign",
                  "skip-validation": "",
                  onDoFormReset: resetInput,
                  onSubmit: onGenerateAccounts
                }, null, 8, ["submit-enable", "submit-label"])) : createCommentVNode("", true),
                isLedger.value ? (openBlock(), createElementBlock("div", _hoisted_21, [
                  createVNode(_sfc_main$9),
                  createVNode(GridSpace, { hr: "" })
                ])) : createCommentVNode("", true),
                isHW.value || signError.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_22, [
                  createBaseVNode("div", _hoisted_23, [
                    signError.value.length === 0 ? (openBlock(), createBlock(IconInfo, {
                      key: 0,
                      class: "w-7 flex-none mr-2"
                    })) : (openBlock(), createBlock(IconError, {
                      key: 1,
                      class: "w-7 flex-none mr-2"
                    })),
                    signError.value.length === 0 ? (openBlock(), createBlock(_sfc_main$7, {
                      key: 2,
                      text: unref(t)(__props.textId + (discoverDialog.value ? ".discoverInfo." : ".info.") + ((_a = unref(walletData)) == null ? void 0 : _a.wallet.signType))
                    }, null, 8, ["text"])) : (openBlock(), createBlock(_sfc_main$7, {
                      key: 3,
                      text: signError.value
                    }, null, 8, ["text"]))
                  ])
                ])) : createCommentVNode("", true),
                isHW.value ? renderSlot(_ctx.$slots, "btnBack", { key: 3 }) : createCommentVNode("", true),
                isHW.value && !discoverDialog.value ? (openBlock(), createBlock(GridButtonSecondary, {
                  key: 4,
                  label: unref(t)("common.label.reset"),
                  link: resetInput,
                  class: "col-start-0 col-span-6"
                }, null, 8, ["label"])) : createCommentVNode("", true),
                isHW.value ? (openBlock(), createBlock(_sfc_main$5, {
                  key: 5,
                  label: discoverDialog.value ? unref(t)(__props.textId + ".button.discover") : accountsToAdd.value.length === 0 ? unref(t)(__props.textId + ".button.remove") : unref(t)(__props.textId + ".button.add"),
                  link: discoverDialog.value ? discoverAccount : onGenerateAccounts,
                  disabled: inputMapContainsError.value,
                  class: "col-start-7 col-span-6"
                }, null, 8, ["label", "link", "disabled"])) : createCommentVNode("", true)
              ])
            ];
          }),
          _: 3
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
function useAccountRewardInfo(walletId, accountId) {
  const appWallet = useAppWallet(walletId);
  const appAccount = useAppAccount(appWallet, accountId);
  const rewardInfo = computed(() => {
    var _a;
    return ((_a = appAccount.value) == null ? void 0 : _a.data.rewardInfoList[0]) ?? null;
  });
  return {
    walletId,
    accountId,
    appWallet,
    appAccount,
    rewardInfo
  };
}
const _hoisted_1$2 = { class: "col-span-12 grid grid-cols-12" };
const _hoisted_2 = { class: "relative w-full flex-1 overflow-hidden flex justify-center items-center" };
const _hoisted_3 = {
  key: 0,
  class: "flex-1 w-full h-full flex flex-col flex-nowrap justify-center items-center"
};
const _hoisted_4 = {
  key: 1,
  class: "flex-1 w-full h-full flex flex-col flex-nowrap justify-center items-center"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "AccountItemDelegation",
  props: {
    walletId: { type: String, required: true },
    accountId: { type: String, required: true },
    isSelectedInUi: { type: Boolean, required: true }
    // This is NOT the globally selectedAccount, but it can be.
  },
  setup(__props) {
    const props = __props;
    const { accountId, walletId } = toRefs(props);
    const { rewardInfo } = useAccountRewardInfo(walletId, accountId);
    const { it } = useTranslation();
    let _currentEpochDelegation = ref([]);
    let _nextDelegation = ref([]);
    let _afterNextDelegations = ref([]);
    async function generateDelegationList() {
      if (!rewardInfo.value) {
        return;
      }
      const _rewardInfo = await updatePoolInRewardInfo(rewardInfo.value);
      _currentEpochDelegation.value.splice(0);
      _nextDelegation.value.splice(0);
      _afterNextDelegations.value.splice(0);
      for (const pool of _rewardInfo.currentEpochDelegation) {
        if (typeof pool === "object") {
          _currentEpochDelegation.value.push(pool);
        }
      }
      for (const pool of _rewardInfo.nextDelegation) {
        if (typeof pool === "object") {
          _nextDelegation.value.push(pool);
        }
      }
      for (const pool of _rewardInfo.afterNextDelegations) {
        if (typeof pool === "object") {
          _afterNextDelegations.value.push(pool);
        }
      }
    }
    const currentEpochDelegation = _currentEpochDelegation;
    const nextDelegation = _nextDelegation;
    const afterNextDelegations = _afterNextDelegations;
    const onUpdate = async () => {
      await generateDelegationList();
    };
    addSignalListener(onPoolDataUpdated, "delegationHistory", onUpdate);
    onUnmounted(() => {
      removeSignalListener(onPoolDataUpdated, "delegationHistory");
    });
    watch(rewardInfo, () => {
      onUpdate();
    }, { immediate: true });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        unref(afterNextDelegations).length > 0 ? (openBlock(), createBlock(_sfc_main$a, {
          key: 0,
          poolList: unref(afterNextDelegations),
          delegatedPoolList: unref(afterNextDelegations),
          selected: __props.isSelectedInUi,
          "info-only": ""
        }, null, 8, ["poolList", "delegatedPoolList", "selected"])) : unref(nextDelegation).length > 0 ? (openBlock(), createBlock(_sfc_main$a, {
          key: 1,
          poolList: unref(nextDelegation),
          delegatedPoolList: unref(nextDelegation),
          selected: __props.isSelectedInUi,
          "info-only": ""
        }, null, 8, ["poolList", "delegatedPoolList", "selected"])) : unref(currentEpochDelegation).length > 0 ? (openBlock(), createBlock(_sfc_main$a, {
          key: 2,
          poolList: unref(currentEpochDelegation),
          delegatedPoolList: unref(currentEpochDelegation),
          selected: __props.isSelectedInUi,
          "info-only": ""
        }, null, 8, ["poolList", "delegatedPoolList", "selected"])) : (openBlock(), createElementBlock("div", {
          key: 3,
          class: normalizeClass(["col-span-12 overflow-hidden cc-area-undelegated flex-1 w-full min-h-16 inline-flex flex-col flex-nowrap justify-start items-start", (__props.isSelectedInUi ? "cc-selected" : "cc-not-selected") + " "])
        }, [
          createBaseVNode("div", _hoisted_2, [
            unref(poolDataList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_3, toDisplayString(unref(it)("wallet.delegation.info.undelegated")), 1)) : (openBlock(), createElementBlock("div", _hoisted_4, toDisplayString(unref(it)("wallet.delegation.info.nodata")), 1))
          ])
        ], 2))
      ]);
    };
  }
});
const _hoisted_1$1 = { class: "col-span-12 sm:col-span-6 xl:col-span-4 grid grid-cols-12 cc-gap" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "AccountItem",
  props: {
    accountId: { type: String, required: true },
    walletId: { type: String, required: true },
    isSelectedInUi: { type: Boolean, required: true },
    // This is NOT the globally selectedAccount, but it can be.
    overwriteShowStake: { type: Boolean, required: true }
  },
  emits: [
    "onActivateAccount",
    "onSetDappAccount",
    "onRemoveAccount",
    "showControlledStake"
  ],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { accountId, walletId } = toRefs(props);
    const { it } = useTranslation();
    function onActivateAccount() {
      emit("onActivateAccount", { walletId: walletId.value, accountId: accountId.value });
    }
    function onSetDappAccount() {
      emit("onSetDappAccount", { walletId: walletId.value, accountId: accountId.value });
    }
    function onRemoveAccount() {
      emit("onRemoveAccount", { walletId: walletId.value, accountId: accountId.value });
    }
    function onShowControlledStake(show) {
      emit("showControlledStake", show);
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createVNode(_sfc_main$b, {
          "wallet-id": unref(walletId),
          "account-id": unref(accountId),
          "is-selected-in-ui": __props.isSelectedInUi,
          "allow-editing-name": true,
          "overwrite-show-stake": __props.overwriteShowStake,
          onOnSetDappAccount: onSetDappAccount,
          onShowControlledStake
        }, null, 8, ["wallet-id", "account-id", "is-selected-in-ui", "overwrite-show-stake"]),
        createVNode(_sfc_main$2, {
          "wallet-id": unref(walletId),
          "account-id": unref(accountId),
          "is-selected-in-ui": __props.isSelectedInUi
        }, null, 8, ["wallet-id", "account-id", "is-selected-in-ui"]),
        !__props.isSelectedInUi ? (openBlock(), createBlock(_sfc_main$c, {
          key: 0,
          label: unref(it)("common.label.remove"),
          link: onRemoveAccount,
          disabled: __props.isSelectedInUi,
          "btn-style": "cc-text-md cc-btn-warning-light",
          class: "col-start-1 col-span-6"
        }, null, 8, ["label", "disabled"])) : createCommentVNode("", true),
        createVNode(_sfc_main$5, {
          class: normalizeClass([__props.isSelectedInUi ? "opacity-0" : "", "col-start-7 col-span-6"]),
          label: __props.isSelectedInUi ? unref(it)("common.label.activeAccount") : unref(it)("common.label.activate"),
          link: onActivateAccount,
          disabled: __props.isSelectedInUi
        }, null, 8, ["class", "label", "disabled"]),
        createVNode(GridSpace, {
          hr: "",
          class: "mt-1.5 col-span-12"
        })
      ]);
    };
  }
});
const _hoisted_1 = { class: "cc-grid cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "AccountList",
  setup(__props) {
    const { it } = useTranslation();
    const { gotoWalletPage } = useNavigation();
    const {
      selectedAccountId,
      selectedWalletId,
      setSelectedAccountId,
      appWallet
    } = useSelectedAccount();
    const hdAccountList = computed(() => {
      const _appWallet = appWallet.value;
      if (!_appWallet) {
        return [];
      }
      return _appWallet.accountList.filter((account) => isHDAccount(account.data.account.path)).sort((a, b) => a.data.account.path[2] - b.data.account.path[2]);
    });
    const $q = useQuasar();
    const showDeleteModal = ref({ display: false });
    const selectedId = ref({ walletId: "", accountId: "" });
    const onActivateAccount = (payload) => {
      if (payload.accountId) {
        setSelectedAccountId(payload.accountId);
        gotoWalletPage("Summary", "accounts");
      }
    };
    const onSetDappAccount = (payload) => {
      if (payload.walletId && payload.accountId) {
        dispatchSignalSync(doToggleDappAccountId, payload.walletId, payload.accountId);
      }
    };
    const openDeleteModal = (payload) => {
      selectedId.value = payload;
      showDeleteModal.value.display = true;
    };
    const _onAccountRemoved = (walletId, accountId, success) => {
      if (walletId === selectedId.value.walletId && accountId === selectedId.value.accountId) {
        return;
      }
      if (!success) {
        $q.notify({
          type: "negative",
          message: "Account could not be removed.",
          position: "top-left",
          timeout: 3e3
        });
      } else {
        $q.notify({
          type: "positive",
          message: "Account removed.",
          position: "top-left",
          timeout: 3e3
        });
      }
    };
    async function onRemoveAccount() {
      if (selectedId.value) {
        addSignalListener(onAccountRemoved, "accountList", _onAccountRemoved);
        await dispatchSignal(doRemoveAccount, selectedId.value.walletId, selectedId.value.accountId);
        removeSignalListener(onAccountRemoved, "accountList");
      }
      showDeleteModal.value.display = false;
    }
    const overwriteShowStake = ref(false);
    function onShowControlledStake(show) {
      if (show) {
        overwriteShowStake.value = show;
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createVNode(_sfc_main$6, {
          label: unref(it)("wallet.summary.accounts.headline")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$7, {
          text: unref(it)("wallet.summary.accounts.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12"
        }),
        unref(appWallet) ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(hdAccountList.value, (appAccount) => {
          return openBlock(), createBlock(_sfc_main$1, {
            key: "item_" + appAccount.id,
            "account-id": appAccount.id,
            "wallet-id": unref(selectedWalletId),
            "overwrite-show-stake": overwriteShowStake.value,
            "is-selected-in-ui": appAccount.id === (unref(selectedAccountId) ?? ""),
            onOnActivateAccount: onActivateAccount,
            onOnSetDappAccount: onSetDappAccount,
            onOnRemoveAccount: openDeleteModal,
            onShowControlledStake
          }, null, 8, ["account-id", "wallet-id", "overwrite-show-stake", "is-selected-in-ui"]);
        }), 128)) : createCommentVNode("", true),
        createVNode(_sfc_main$d, {
          class: "col-span-12",
          css: "cc-area-highlight cc-text-semi-bold",
          dense: "",
          label: unref(it)("wallet.summary.accounts.notice.label"),
          text: unref(it)("wallet.summary.accounts.notice.text"),
          icon: unref(it)("wallet.summary.accounts.notice.icon")
        }, null, 8, ["label", "text", "icon"]),
        createVNode(GridSpace, {
          hr: "",
          class: "mt-1 col-span-12"
        }),
        createVNode(_sfc_main$3, {
          "text-id": "wallet.summary.accounts.confirm",
          class: "col-span-12 mb-0 sm:mb-1 lg:mb-2"
        }),
        createVNode(_sfc_main$e, {
          "show-modal": showDeleteModal.value,
          title: unref(it)("wallet.summary.accounts.remove.label"),
          caption: unref(it)("wallet.summary.accounts.remove.caption"),
          onConfirm: onRemoveAccount
        }, null, 8, ["show-modal", "title", "caption"])
      ]);
    };
  }
});
export {
  _sfc_main as default
};
