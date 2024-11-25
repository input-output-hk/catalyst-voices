import { eD as AccountDB, eE as el, eF as sl, eG as getLegacyNotes, eH as createValueJSON, eI as getAddressCredentials, eJ as getOwnedCred, c_ as add, eK as addValueToValue, eL as createIUtxo, eM as decodeHex, c6 as getAssetIdBech32, eN as createITxBalance, eO as RefDB, eP as CertificateTypes, eQ as createJsonFromCborJson, a2 as now, bi as getUtxoHash, eR as loadUtxoCborFromTxList, eS as loadUtxoByronList, eT as getCSLTransactionOutput, eU as getTransactionOutputJSONFromCSL, b0 as safeFreeCSLObject, eV as createIUtxoFromIUtxoDetails, cP as ITxBalanceType, eW as compare, cJ as abs, z as ref, f as computed, d as defineComponent, a7 as useQuasar, eX as numTxTotal, eY as numTxLoaded, aG as onUnmounted, o as openBlock, c as createElementBlock, e as createBaseVNode, q as createVNode, u as unref, j as createCommentVNode, a as createBlock, t as toDisplayString, Q as QSpinnerDots_default, H as Fragment, I as renderList, cb as QToggle_default, ae as useSelectedAccount, k as dispatchSignalSync, l as doForceSyncImportantAccounts, eZ as HistoryDB, e_ as getRewardHistory, D as watch, ar as appLanguageTag, h as withCtx, cc as QBtn_default, cd as QPopupProxy_default, ce as QDate_default, F as withDirectives, e$ as ClosePopup_default, b as withModifiers, f0 as QTime_default, i as createTextVNode, al as appUseUtc, B as useFormatter, f1 as getCalculatedSlotFromBlockTime, K as networkId, cZ as multiply, f2 as createTxSearchConfig, f3 as hasSearchConfig, f4 as txListPage, ct as onErrorCaptured, f5 as getPendingTxList, f6 as numItemsPerPage, C as onMounted, eA as Transition, n as normalizeClass, f7 as numMaxSearchResults, f8 as currentPage, R as isRef, f9 as numMaxPages, aH as QPagination_default, fa as isUpdating, fb as searchTxList, c3 as isZero } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useTabId } from "./useTabId.js";
import { _ as _sfc_main$3, a as _sfc_main$4 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$7 } from "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import { I as ICSVExportTargetId, u as useCSVExport } from "./useCSVExport.js";
import { g as getRewardInfoRefId } from "./reward.js";
import { u as useDownload } from "./useDownload.js";
import { _ as _sfc_main$6 } from "./GridTxListBalance.vue_vue_type_script_setup_true_lang.js";
import { u as useDarkMode } from "./useDarkMode.js";
import { u as useAdaSymbol } from "./useAdaSymbol.js";
import { _ as _sfc_main$5 } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { I as IconError } from "./IconError.js";
import { G as GridInput } from "./GridInput.js";
import { I as IconWarning } from "./IconWarning.js";
import { M as Modal } from "./Modal.js";
import "./NetworkId.js";
import "./_plugin-vue_export-helper.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./vue-json-pretty.js";
import "./GridTxListEntryBalance.vue_vue_type_script_setup_true_lang.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./GridTxListUtxoListBadges.vue_vue_type_script_setup_true_lang.js";
import "./useNavigation.js";
import "./ReportLabelNewModal.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
import "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
import "./AccessPasswordInputModal.vue_vue_type_script_setup_true_lang.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
const storeId = "txbalance";
const doLog = false;
const loadedUtxoCborMap = {};
const getITxBalanceType = (tx, txBalance, hasWithdrawal) => {
  let type = ITxBalanceType.uninitialized;
  if (hasWithdrawal) {
    type = type | ITxBalanceType.withdrawal;
  }
  if (txBalance.multiasset && Object.values(txBalance.multiasset).some((assets) => Object.values(assets).some((amount) => compare(amount, ">", 0)))) {
    type = type | ITxBalanceType.receivedTokens;
  }
  if (txBalance.multiasset && Object.values(txBalance.multiasset).some((assets) => Object.values(assets).some((amount) => compare(amount, "<", 0)))) {
    type = type | ITxBalanceType.sentTokens;
  }
  if (compare(abs(txBalance.coin), "==", tx.body.fee)) {
    type = type | ITxBalanceType.intraWallet;
  }
  if (compare(txBalance.coin, "<", 0)) {
    type = type | ITxBalanceType.sentAda;
  } else if (compare(txBalance.coin, ">", 0)) {
    if (!((type & ITxBalanceType.withdrawal) === ITxBalanceType.withdrawal)) {
      type = type | ITxBalanceType.receivedAda;
    }
  } else {
    type = type | ITxBalanceType.external;
  }
  return type;
};
const getSendITxBalance = async (networkId2, accountId, tx) => {
  var _a;
  if (!tx) {
    return null;
  }
  const start = now();
  let time = start;
  try {
    const accountKeys = await AccountDB.getKeys(networkId2, accountId);
    if (!accountKeys) {
      console.error(el(storeId), sl("getSendITxBalance"), "failed to fetch account keys");
      throw "failed to fetch account keys";
    }
    const _tx = {
      hash: tx.hash ?? "",
      slot: 0,
      idx: 0,
      block: 0,
      json: tx
    };
    await loadUnknownInputUtxos(networkId2, accountId, getUnknownInputUtxoHashList(tx), tx.inputUtxoList);
    const legacyNotes = await getLegacyNotes();
    let debugCnt = 1;
    const balance = createValueJSON();
    const uniqueAddressSet = /* @__PURE__ */ new Set();
    let ownWithdrawals = null;
    if (tx.body.withdrawals) {
      for (const withdrawal of Object.entries(tx.body.withdrawals)) {
        const credentials = getAddressCredentials(withdrawal[0]);
        if (credentials.stakeCred && getOwnedCred([accountKeys], credentials.stakeCred, "stake")) {
          ownWithdrawals = add(ownWithdrawals ?? "0", withdrawal[1]);
        }
      }
    }
    if (ownWithdrawals) {
      addValueToValue(balance, { coin: ownWithdrawals }, true);
    }
    for (const input of tx.body.inputs) {
      const utxo = tx.inputUtxoList.find((utxo2) => utxo2.input.transaction_id === input.transaction_id && utxo2.input.index === input.index);
      if (!utxo) {
        console.warn(el(storeId), sl("getSendITxBalance"), `input details missing: hash=${input.transaction_id}, index=${input.index}`);
        continue;
      }
      if (utxo.pc.length > 0) {
        if (getOwnedCred([accountKeys], utxo.pc)) {
          addValueToValue(balance, utxo.output.amount, true);
        }
        uniqueAddressSet.add(utxo.pc);
      }
      uniqueAddressSet.add(utxo.output.address);
    }
    for (let i = 0; i < tx.body.outputs.length; i++) {
      const output = createIUtxo({ input: { transaction_id: _tx.hash, index: i }, output: tx.body.outputs[i] });
      if (output.pc.length > 0) {
        if (getOwnedCred([accountKeys], output.pc)) {
          addValueToValue(balance, output.output.amount);
        }
        uniqueAddressSet.add(output.pc);
      }
      uniqueAddressSet.add(output.output.address);
    }
    const uniqueAssetNameSet = /* @__PURE__ */ new Set();
    if (balance.multiasset) {
      for (const polidyId in balance.multiasset) {
        for (const assetName in balance.multiasset[polidyId]) {
          uniqueAssetNameSet.add(decodeHex(assetName));
          uniqueAssetNameSet.add(getAssetIdBech32(polidyId, assetName));
        }
      }
    }
    const txBalance = createITxBalance({ hash: _tx.hash, slot: _tx.slot, idx: _tx.idx });
    const refIdList = await RefDB.addRefList(networkId2, accountId, Array.from(uniqueAddressSet).concat(Array.from(uniqueAssetNameSet)));
    txBalance.block = _tx.block;
    txBalance.coin = balance.coin;
    if (balance.multiasset) {
      txBalance.multiasset = balance.multiasset;
    }
    txBalance.c = Number(balance.coin);
    txBalance.t = getITxBalanceType(tx, txBalance, ownWithdrawals !== null);
    if (!!tx.witness_set.native_scripts) {
      txBalance.n = true;
    }
    if (!!(tx.witness_set.plutus_data || tx.witness_set.plutus_scripts || tx.witness_set.redeemers)) {
      txBalance.p = true;
    }
    for (const cert of tx.body.certs ?? []) {
      const id = CertificateTypes.findIndex((type) => type === Object.keys(cert)[0]);
      if (id >= 0) {
        txBalance.cert ? txBalance.cert.push(id) : txBalance.cert = [id];
      } else {
        console.warn("getSendITxBalance: unknown certificate type: ", Object.keys(cert)[0]);
      }
    }
    for (const address of uniqueAddressSet) {
      const ref2 = refIdList.find((ref22) => ref22.ref === address);
      if (!ref2) {
        throw Error("getSendITxBalance: address ref not found: " + address);
      }
      txBalance.al.push(ref2.id);
    }
    for (const assetName of uniqueAssetNameSet) {
      const ref2 = refIdList.find((ref22) => ref22.ref === assetName);
      if (!(ref2 == null ? void 0 : ref2.id)) {
        throw Error("getSendITxBalance: tag ref not found: " + assetName);
      }
      txBalance.tags ? txBalance.tags.push(ref2.id) : txBalance.tags = [ref2.id];
    }
    if ((_a = tx.auxiliary_data) == null ? void 0 : _a.metadata) {
      const label674 = tx.auxiliary_data.metadata["674"];
      if (label674) {
        const msg = {};
        createJsonFromCborJson(JSON.parse(label674), msg);
        if (msg.msg && Array.isArray(msg.msg)) {
          txBalance.msg = msg.msg;
        }
        if (msg.enc && typeof msg.enc === "string") {
          txBalance.enc = msg.enc;
        }
      }
      for (const key of Object.keys(tx.auxiliary_data.metadata)) {
        txBalance.mk ? txBalance.mk.push(Number(key)) : txBalance.mk = [Number(key)];
      }
    }
    const note = legacyNotes.find((n) => n.txHash === _tx.hash);
    if (note) {
      txBalance.note = note.note;
    }
    if (doLog) ;
    return txBalance;
  } catch (err) {
    console.error(el(storeId), sl("getSendITxBalance"), accountId, err);
    throw err;
  }
};
const getUnknownInputUtxoHashList = (tx) => {
  tx.inputUtxoList = tx.inputUtxoList ?? new Array();
  const inputHashSet = /* @__PURE__ */ new Set();
  for (const input of tx.body.reference_inputs ?? []) {
    inputHashSet.add(getUtxoHash(input));
  }
  for (const input of tx.body.collateral ?? []) {
    inputHashSet.add(getUtxoHash(input));
  }
  for (const input of tx.body.inputs ?? []) {
    inputHashSet.add(getUtxoHash(input));
  }
  for (const utxo of tx.inputUtxoList ?? []) {
    inputHashSet.delete(getUtxoHash(utxo.input));
  }
  return Array.from(inputHashSet);
};
const loadUnknownInputUtxos = async (networkId2, accountId, inputHashList, inputUtxoList) => {
  const _inputHashList = inputHashList.concat();
  const inputUtxoCborList = [];
  for (let i = _inputHashList.length; i >= 0; i--) {
    const utxoCbor = loadedUtxoCborMap[_inputHashList[i]];
    if (utxoCbor) {
      inputUtxoCborList.push(utxoCbor);
      _inputHashList.splice(i, 1);
    }
  }
  if (_inputHashList.length > 0) {
    const loadedUtxoCborList = await loadUtxoCborFromTxList(networkId2, accountId, _inputHashList);
    for (const cbor of loadedUtxoCborList) {
      inputUtxoCborList.push(cbor);
      loadedUtxoCborMap[cbor.hash] = cbor;
    }
  }
  let utxoByronList = null;
  if (inputUtxoCborList.length !== inputHashList.length) {
    const missingUtxoList = inputHashList.filter((i) => !inputUtxoCborList.some((cbor) => cbor.hash === i));
    const missingUtxoArr = new Array(missingUtxoList.length);
    for (let i = 0; i < missingUtxoList.length; i++) {
      missingUtxoArr[i] = missingUtxoList[i].split("#");
    }
    utxoByronList = await loadUtxoByronList(networkId2, accountId, missingUtxoArr);
    if (!utxoByronList || inputUtxoCborList.length + utxoByronList.length !== inputHashList.length) {
      console.warn(el(storeId), sl("loadUnknownInputUtxos"), `incomplete cbor response compared to unknown input list:
        id=${accountId}, inputs=${inputHashList.length}, cbor=${inputUtxoCborList.length}, byron=${(utxoByronList == null ? void 0 : utxoByronList.length) ?? 0}`);
      return null;
    }
  }
  for (let i = 0; i < inputUtxoCborList.length; i++) {
    const inputArr = inputUtxoCborList[i].hash.split("#");
    const input = {
      transaction_id: inputArr[0],
      index: parseInt(inputArr[1])
    };
    const cslOutput = getCSLTransactionOutput(inputUtxoCborList[i].cbor);
    const output = getTransactionOutputJSONFromCSL(networkId2, cslOutput);
    const utxo = createIUtxo({ input, output });
    inputUtxoList.push(utxo);
    safeFreeCSLObject(cslOutput);
  }
  for (const byronInput of utxoByronList ?? []) {
    inputUtxoList.push(createIUtxoFromIUtxoDetails(byronInput));
  }
};
const exportMenuOpen = ref(false);
const useExportMenuOpen = () => {
  const openExportMenu = () => {
    exportMenuOpen.value = true;
  };
  const closeExportMenu = () => {
    exportMenuOpen.value = false;
  };
  const toggleExportMenu = () => {
    exportMenuOpen.value = !exportMenuOpen.value;
  };
  const isExportMenuOpen = computed(() => exportMenuOpen.value);
  return {
    openExportMenu,
    closeExportMenu,
    toggleExportMenu,
    isExportMenuOpen
  };
};
const _hoisted_1$2 = { class: "w-full col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_2$2 = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_3$2 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 cc-gap cc-banner-warning cc-rounded p-2"
};
const _hoisted_4$2 = {
  key: 2,
  class: "col-span-12 flex flex-row items-center gap-2"
};
const _hoisted_5$2 = ["selected", "value"];
const _hoisted_6$2 = { class: "col-span-12 flex flex-row flex-nowrap gap-2" };
const _hoisted_7$2 = { class: "col-span-12 flex flex-row flex-nowrap gap-2 justify-between" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "ExportCSV",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.exports" }
  },
  setup(__props) {
    const $q = useQuasar();
    const { it } = useTranslation();
    const { downloadText } = useDownload();
    const {
      selectedAccountId,
      appAccount,
      accountData,
      accountSettings,
      walletData
    } = useSelectedAccount();
    const enableHistorySync = accountSettings.enableHistorySync;
    const rewardInfo = accountSettings.rewardInfo;
    accountSettings.stakeKey;
    const isHistorySyncEnabled = accountSettings.isHistorySyncEnabled;
    const isManualSyncEnabled = accountSettings.isManualSyncEnabled;
    const disableHistorySync = accountSettings.disableHistorySync;
    const needFullSync = computed(() => numTxTotal.value !== numTxLoaded.value);
    const wasSyncActive = ref(isHistorySyncEnabled.value);
    const isSyncingHistory = computed(() => !isManualSyncEnabled.value && needFullSync.value);
    const status = computed(() => numTxLoaded.value + " / " + numTxTotal.value + " transactions.");
    const syncCheckInterval = ref(-1);
    const {
      getCSVTarget,
      getCSVTargetList,
      createCSVFile
    } = useCSVExport();
    const exportTargets = getCSVTargetList();
    const selectedTargetId = ref(ICSVExportTargetId.universal);
    const noteToggle = ref(false);
    const timezoneToggle = ref(false);
    const doSync = async () => {
      if (!isHistorySyncEnabled.value) {
        await enableHistorySync();
        dispatchSignalSync(doForceSyncImportantAccounts);
      }
      if (!accountData.value) {
        return;
      }
      clearInterval(syncCheckInterval.value);
      syncCheckInterval.value = setInterval(async () => {
        if (numTxTotal.value === numTxLoaded.value) {
          clearInterval(syncCheckInterval.value);
          $q.notify({
            type: "positive",
            message: it("preferences.exports.transactions.syncNote.ready"),
            position: "top-left",
            timeout: 4e3
          });
          if (!wasSyncActive.value) {
            await disableHistorySync();
          }
        }
      }, 300);
    };
    function onExportTargetChange(event) {
      selectedTargetId.value = exportTargets[event.target.options.selectedIndex].id;
    }
    async function doExportCSV() {
      const account = accountData.value;
      if (!account) {
        showError("No active account set.");
        return;
      }
      if (!account.settings.networkId) {
        showError("No network set.");
        return;
      }
      const txList = await HistoryDB.getTxHistory(account.settings.networkId, selectedAccountId.value, numTxTotal.value, numTxTotal.value);
      const stakeInfo = account.keys.stake;
      if (!txList || txList.length === 0) {
        showError("No transactions to export.");
        return;
      }
      if (!stakeInfo) {
        showError("No rewards info available.");
        return;
      }
      const target = getCSVTarget(selectedTargetId.value);
      const rewardList = await getRewardList();
      const csv = createCSVFile(account.state.networkId, txList, rewardList, target, it, timezoneToggle.value, noteToggle.value);
      const walletName = walletData.value.settings.name ?? "";
      const walletId = walletData.value.settings.id ?? "";
      const fileName = "eternlio-" + walletName.replace(/\s/g, "-") + "-" + walletId.toLowerCase().replace(/\s/g, "-") + "-" + target.id + ".csv";
      await downloadText(csv, fileName);
    }
    const getRewardList = async () => {
      if (selectedAccountId.value.length === 0 || !rewardInfo.value) {
        return [];
      }
      const refIdList = await getRewardInfoRefId(rewardInfo.value);
      if (refIdList.length === 0) {
        return [];
      }
      let refId = refIdList[0];
      let rewardHistoryCount = await HistoryDB.getRewardHistoryCount(selectedAccountId.value, refId);
      let epochData = await getRewardHistory(selectedAccountId.value, refId, rewardHistoryCount, 0, false);
      return epochData.sort((a, b) => a.epochNo <= b.epochNo ? -1 : 1);
    };
    function showError(msg) {
      $q.notify({
        type: "negative",
        message: msg,
        position: "top-left",
        timeout: 4e3
      });
    }
    onUnmounted(async () => {
      clearInterval(syncCheckInterval.value);
      if (!wasSyncActive.value) {
        await disableHistorySync();
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        createBaseVNode("div", _hoisted_2$2, [
          createVNode(_sfc_main$3, {
            label: unref(it)(__props.textId + ".csv.headline")
          }, null, 8, ["label"]),
          createVNode(_sfc_main$4, {
            text: unref(it)(__props.textId + ".csv.caption")
          }, null, 8, ["text"]),
          needFullSync.value ? (openBlock(), createElementBlock("div", _hoisted_3$2, [
            createVNode(_sfc_main$3, {
              label: unref(it)("preferences.exports.transactions.syncNote.label")
            }, null, 8, ["label"]),
            createVNode(_sfc_main$4, {
              text: unref(it)("preferences.exports.transactions.syncNote.caption")
            }, null, 8, ["text"])
          ])) : createCommentVNode("", true),
          needFullSync.value ? (openBlock(), createBlock(GridButtonSecondary, {
            key: 1,
            class: "col-span-12 h-10 mt-1",
            link: doSync,
            label: unref(it)("preferences.exports.transactions.syncNote.button.label"),
            icon: unref(it)("preferences.exports.transactions.syncNote.button.icon")
          }, null, 8, ["label", "icon"])) : createCommentVNode("", true),
          isSyncingHistory.value ? (openBlock(), createElementBlock("div", _hoisted_4$2, [
            createBaseVNode("span", null, toDisplayString(status.value), 1),
            createVNode(QSpinnerDots_default, {
              color: "gray",
              size: "1em"
            })
          ])) : createCommentVNode("", true),
          createVNode(_sfc_main$3, {
            label: unref(it)(__props.textId + ".csv.format")
          }, null, 8, ["label"]),
          createBaseVNode("select", {
            class: "col-span-12 md:col-span-6 cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[0] || (_cache[0] = ($event) => onExportTargetChange($event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(exportTargets), (target) => {
              return openBlock(), createElementBlock("option", {
                selected: target.id === selectedTargetId.value,
                value: target.label
              }, toDisplayString(target.label), 9, _hoisted_5$2);
            }), 256))
          ], 32),
          createVNode(_sfc_main$3, {
            label: unref(it)(__props.textId + ".csv.notes.label")
          }, null, 8, ["label"]),
          createBaseVNode("div", _hoisted_6$2, [
            createVNode(_sfc_main$4, {
              class: "shrink",
              text: unref(it)(__props.textId + ".csv.notes.caption")
            }, null, 8, ["text"]),
            createVNode(QToggle_default, {
              modelValue: noteToggle.value,
              "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => noteToggle.value = $event)
            }, null, 8, ["modelValue"])
          ]),
          createVNode(_sfc_main$3, {
            label: unref(it)(__props.textId + ".csv.localTime.label")
          }, null, 8, ["label"]),
          createBaseVNode("div", _hoisted_7$2, [
            createVNode(_sfc_main$4, {
              class: "shrink",
              text: unref(it)(__props.textId + ".csv.localTime.caption")
            }, null, 8, ["text"]),
            createVNode(QToggle_default, {
              modelValue: timezoneToggle.value,
              "onUpdate:modelValue": _cache[2] || (_cache[2] = ($event) => timezoneToggle.value = $event)
            }, null, 8, ["modelValue"])
          ]),
          createVNode(GridButtonSecondary, {
            class: "col-span-12 h-10 mt-1",
            link: doExportCSV,
            label: unref(it)(__props.textId + ".csv.button.label"),
            icon: unref(it)(__props.textId + ".csv.button.icon")
          }, null, 8, ["label", "icon"])
        ])
      ]);
    };
  }
});
const _hoisted_1$1 = { class: "col-span-12 flex flex-row flex-nowrap items-center cc-gap-lg mb-2" };
const _hoisted_2$1 = { class: "capitalize cc-text-bold" };
const _hoisted_3$1 = { class: "flex flex-row flex-nowrap items-center cc-gap-lg" };
const _hoisted_4$1 = { class: "q-gutter-sm row" };
const _hoisted_5$1 = { class: "row items-center justify-end q-gutter-sm" };
const _hoisted_6$1 = {
  key: 0,
  class: "cc-addr cc-text-sm"
};
const _hoisted_7$1 = { class: "md:whitespace-nowrap" };
const _hoisted_8$1 = { class: "cc-text-semi-bold whitespace-nowrap" };
const _hoisted_9$1 = { key: 0 };
const _hoisted_10$1 = {
  key: 0,
  class: ""
};
const _hoisted_11$1 = {
  key: 0,
  class: "cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_12$1 = { key: 0 };
const _hoisted_13$1 = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_14$1 = { class: "text-md ml-1.5" };
const _hoisted_15$1 = { class: "text-md ml-1.5" };
const _hoisted_16$1 = {
  key: 0,
  class: "col-span-12 flex flex-row flex-nowrap whitespace-pre-wrap"
};
const _hoisted_17 = {
  key: 0,
  class: "col-span-12 flex flex-row flex-nowrap items-center"
};
const _hoisted_18 = { class: "flex flex-col flex-nowrap cc-text-sz" };
const _hoisted_19 = { class: "flex flex-row items-center" };
const _hoisted_20 = {
  key: 0,
  class: "flex flex-row items-center"
};
const _hoisted_21 = { class: "mt-0.5 ml-0.5 cc-addr" };
const _hoisted_22 = { class: "mt-0.5 ml-0.5 cc-addr" };
const _hoisted_23 = { key: 0 };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "TxFilters",
  emits: ["submit", "reset"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { t } = useTranslation();
    const { adaSymbol } = useAdaSymbol();
    const { isDarkMode } = useDarkMode();
    const {
      formatDatetime,
      formatADAString,
      formatAmountString,
      getDecimalNumber,
      valueFromFormattedString,
      getNumberFormatSeparators
    } = useFormatter();
    const {
      accountSettings
    } = useSelectedAccount();
    const isHistorySyncEnabled = accountSettings.isHistorySyncEnabled;
    const totalTxCnt = numTxTotal;
    const loadedTxCnt = numTxLoaded;
    const needFullSync = computed(() => numTxTotal.value !== numTxLoaded.value);
    const decimalNumber = getDecimalNumber();
    let formatSeparators = getNumberFormatSeparators();
    const decimalSeparator = ref(formatSeparators.decimal);
    const groupSeparator = ref(formatSeparators.group);
    const minusSign = ref(formatSeparators.minusSign);
    computed(() => totalTxCnt.value !== loadedTxCnt.value);
    watch(appLanguageTag, () => {
      formatSeparators = getNumberFormatSeparators();
      decimalSeparator.value = formatSeparators.decimal;
      groupSeparator.value = formatSeparators.group;
      minusSign.value = formatSeparators.minusSign;
      onFilterReset();
    }, { deep: true });
    const filterError = ref("");
    const fDateRangeProxy = ref(null);
    const fDateRange = ref(null);
    const isSingleDay = computed(() => {
      var _a;
      return !((_a = fDateRange.value) == null ? void 0 : _a.from);
    });
    const filterTimeStart = ref(false);
    const filterTimeEnd = ref(false);
    const fTimeStartProxy = ref(null);
    const fTimeEndProxy = ref(null);
    const vTimeStartProxy = ref(null);
    const vTimeEndProxy = ref(null);
    const startDateSet = ref(false);
    const endDateSet = ref(false);
    const fInputMin = ref("");
    const fInputMinLovelace = ref(null);
    const fInputMax = ref("");
    const fInputMaxLovelace = ref(null);
    const fSearchInput = ref("");
    let searchConfig = null;
    function validateAdaMinInput(newValue, oldValue) {
      var _a;
      if (newValue && newValue.length !== oldValue.length) {
        filterError.value = "";
        if (newValue.startsWith(minusSign.value) || newValue.startsWith("-")) {
          newValue = minusSign.value + (((_a = newValue == null ? void 0 : newValue.replace(minusSign.value, "")) == null ? void 0 : _a.replace(/-/g, "")) ?? newValue);
          if (newValue.replace(/[^0-9]/g, "").length === 0) {
            fInputMin.value = minusSign.value;
            return;
          }
        }
        const ada = valueFromFormattedString(newValue, 0);
        fInputMin.value = formatAmountString(ada.whole, true, true);
      } else {
        fInputMin.value = "";
      }
    }
    function validateAdaMaxInput(newValue, oldValue) {
      var _a;
      if (newValue && newValue.length !== oldValue.length) {
        filterError.value = "";
        if (newValue.startsWith(minusSign.value) || newValue.startsWith("-")) {
          newValue = minusSign.value + (((_a = newValue == null ? void 0 : newValue.replace(minusSign.value, "")) == null ? void 0 : _a.replace(/-/g, "")) ?? newValue);
          if (newValue.replace(/[^0-9]/g, "").length === 0) {
            fInputMax.value = minusSign.value;
            return;
          }
        }
        const ada = valueFromFormattedString(newValue, 0);
        fInputMax.value = formatAmountString(ada.whole, true, true);
      } else {
        fInputMax.value = "";
      }
    }
    function updateMinMaxAda() {
      let minAda;
      let maxAda;
      if (fInputMin.value.length === 0 || fInputMin.value === minusSign.value) {
        fInputMinLovelace.value = null;
      } else {
        minAda = valueFromFormattedString(fInputMin.value, 0);
        fInputMinLovelace.value = multiply(minAda.whole, decimalNumber);
      }
      if (fInputMax.value.length === 0 || fInputMax.value === minusSign.value) {
        fInputMaxLovelace.value = null;
      } else {
        maxAda = valueFromFormattedString(fInputMax.value, 0);
        if (minAda && compare(maxAda.whole, "<=", minAda.whole)) {
          const newValue = add(minAda.whole, 1);
          fInputMaxLovelace.value = multiply(newValue, decimalNumber);
          fInputMax.value = formatAmountString(newValue, true, true);
        } else {
          fInputMaxLovelace.value = multiply(maxAda.whole, decimalNumber);
        }
      }
    }
    function updateDateRangeFilter() {
      startDateSet.value = false;
      endDateSet.value = false;
      fTimeStartProxy.value = null;
      vTimeStartProxy.value = null;
      fTimeEndProxy.value = null;
      vTimeEndProxy.value = null;
      filterTimeStart.value = false;
      filterTimeEnd.value = false;
      if (fDateRange.value) {
        fDateRangeProxy.value = fDateRange.value;
      } else {
        const date = /* @__PURE__ */ new Date();
        fDateRangeProxy.value = { from: date.getFullYear() + "/" + date.getMonth() + "/" + date.getDay(), to: date.getFullYear() + "/" + date.getMonth() + "/" + date.getDay() };
      }
    }
    function saveDateRangeFilter() {
      var _a;
      if (fDateRangeProxy.value) {
        const startTime = fTimeStartProxy.value;
        const endTime = fTimeEndProxy.value;
        if (!((_a = fDateRangeProxy.value) == null ? void 0 : _a.from)) {
          fDateRange.value = { from: null, to: null };
          if (fTimeStartProxy.value !== null) {
            filterTimeStart.value = true;
            let fromDate = new Date(fDateRangeProxy.value);
            if (startTime) {
              fromDate.setHours(startTime.getHours());
              fromDate.setMinutes(startTime.getMinutes());
            }
            fDateRange.value.from = fromDate;
          } else {
            filterTimeStart.value = false;
            const fromDate = new Date(fDateRangeProxy.value);
            fromDate.setHours(0);
            fromDate.setMinutes(0);
            fromDate.setSeconds(0);
            fDateRange.value.from = fromDate;
          }
          if (fTimeEndProxy.value !== null) {
            filterTimeEnd.value = true;
            let toDate = new Date(fDateRangeProxy.value);
            if (endTime) {
              toDate.setHours(endTime.getHours());
              toDate.setMinutes(endTime.getMinutes());
            }
            fDateRange.value.to = toDate;
          } else {
            filterTimeEnd.value = false;
            const toDate = new Date(fDateRangeProxy.value);
            toDate.setHours(23);
            toDate.setMinutes(59);
            toDate.setSeconds(59);
            fDateRange.value.to = toDate;
          }
        } else {
          fDateRange.value = fDateRangeProxy.value;
          if (fTimeStartProxy.value !== null) {
            filterTimeStart.value = true;
            const startDate = new Date(fDateRange.value.from);
            startDate.setTime(new Date(fTimeStartProxy.value).getTime());
            startDate.setDate(new Date(fDateRange.value.from).getDate());
            fDateRange.value.from = startDate;
          }
          if (fTimeEndProxy.value !== null) {
            filterTimeEnd.value = true;
            const endDate = new Date(fDateRange.value.to);
            endDate.setTime(new Date(fTimeEndProxy.value).getTime());
            endDate.setDate(new Date(fDateRange.value.to).getDate());
            fDateRange.value.to = endDate;
          } else {
            const endDate = new Date(fDateRange.value.to);
            endDate.setDate(new Date(fDateRange.value.to).getDate());
            endDate.setHours(23);
            endDate.setMinutes(59);
            endDate.setSeconds(59);
            fDateRange.value.to = endDate;
          }
        }
      } else {
        fDateRange.value = null;
      }
    }
    function onFilterReset() {
      fDateRange.value = null;
      updateDateRangeFilter();
      fInputMin.value = "";
      fInputMax.value = "";
      fSearchInput.value = "";
      searchConfig = null;
      emit("reset");
    }
    function onFilterSubmit() {
      updateMinMaxAda();
      searchConfig = createTxSearchConfig();
      if (fInputMinLovelace.value) {
        searchConfig.coinLow = Number(fInputMinLovelace.value);
      }
      if (fInputMaxLovelace.value) {
        searchConfig.coinHigh = Number(fInputMaxLovelace.value);
      }
      if (fDateRange.value) {
        if (fDateRange.value.from) {
          if (typeof fDateRange.value.from === "string") {
            fDateRange.value.from = new Date(fDateRange.value.from);
          }
          const from = appUseUtc.value ? fDateRange.value.from : convertDateToUTC(fDateRange.value.from);
          searchConfig.slotStart = getCalculatedSlotFromBlockTime(networkId.value, from.getTime());
        }
        if (fDateRange.value.to) {
          if (typeof fDateRange.value.to === "string") {
            fDateRange.value.to = new Date(fDateRange.value.to);
          }
          const to = appUseUtc.value ? fDateRange.value.to : convertDateToUTC(fDateRange.value.to);
          searchConfig.slotEnd = getCalculatedSlotFromBlockTime(networkId.value, to.getTime());
        }
        console.log("searchConfig", searchConfig);
      }
      if (fSearchInput.value && fSearchInput.value.length > 0) {
        let str = fSearchInput.value;
        if (str.startsWith('"')) {
          str = str.substring(1);
        }
        if (str.endsWith('"')) {
          str = str.substring(0, str.length - 1);
        }
        const txSplit = str.split("#");
        if (txSplit.length === 2 && txSplit[0].length === 64) {
          str = txSplit[0];
        }
        searchConfig.searchStr = str.trim();
      }
      emit("submit", searchConfig);
    }
    const setRangeStart = (event) => {
      startDateSet.value = true;
      endDateSet.value = false;
    };
    const setRangeEnd = (event) => {
      endDateSet.value = true;
    };
    function convertDateToUTC(date) {
      return new Date(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds());
    }
    const updateStartTime = (event) => {
      fTimeStartProxy.value = new Date(event);
      vTimeStartProxy.value = new Date(event);
      if (!appUseUtc.value) {
        fTimeStartProxy.value = convertDateToUTC(fTimeStartProxy.value);
      }
    };
    const updateEndTime = (event) => {
      fTimeEndProxy.value = new Date(event);
      vTimeEndProxy.value = new Date(event);
      if (!appUseUtc.value) {
        fTimeEndProxy.value = convertDateToUTC(fTimeEndProxy.value);
      }
    };
    const closeDateSelect = () => {
      endDateSet.value = false;
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(_sfc_main$5, {
          onDoFormReset: onFilterReset,
          onDoFormSubmit: onFilterSubmit,
          "form-id": "'txFilters'",
          "reset-button-label": unref(t)("common.label.reset"),
          "submit-button-label": unref(t)("common.label.apply"),
          class: "col-span-12 mb-2"
        }, {
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_1$1, [
              createBaseVNode("span", _hoisted_2$1, toDisplayString(unref(t)("wallet.transactions.filter.period.label")), 1),
              createBaseVNode("div", _hoisted_3$1, [
                createVNode(QBtn_default, {
                  icon: "event",
                  round: "",
                  color: "primary"
                }, {
                  default: withCtx(() => [
                    createVNode(QPopupProxy_default, {
                      onBeforeShow: updateDateRangeFilter,
                      cover: "",
                      "transition-show": "scale",
                      "transition-hide": "scale",
                      class: "bg-transparent"
                    }, {
                      default: withCtx(() => [
                        createBaseVNode("div", _hoisted_4$1, [
                          createVNode(QDate_default, {
                            range: "",
                            modelValue: fDateRangeProxy.value,
                            "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => fDateRangeProxy.value = $event),
                            mask: "YYYY-MM-DD HH:mm",
                            onRangeEnd: setRangeEnd,
                            onRangeStart: setRangeStart,
                            onClose: closeDateSelect,
                            dark: unref(isDarkMode)
                          }, {
                            default: withCtx(() => [
                              createBaseVNode("div", _hoisted_5$1, [
                                withDirectives(createVNode(QBtn_default, {
                                  label: "Cancel",
                                  color: "primary",
                                  flat: ""
                                }, null, 512), [
                                  [ClosePopup_default]
                                ]),
                                withDirectives(createVNode(QBtn_default, {
                                  label: "OK",
                                  color: "primary",
                                  flat: "",
                                  onClick: withModifiers(saveDateRangeFilter, ["stop"])
                                }, null, 512), [
                                  [ClosePopup_default]
                                ])
                              ])
                            ]),
                            _: 1
                          }, 8, ["modelValue", "dark"]),
                          fTimeStartProxy.value && startDateSet.value && !endDateSet.value ? (openBlock(), createBlock(QTime_default, {
                            key: 0,
                            range: "",
                            modelValue: fTimeStartProxy.value,
                            "onUpdate:modelValue": [
                              _cache[1] || (_cache[1] = ($event) => fTimeStartProxy.value = $event),
                              updateStartTime
                            ],
                            mask: "YYYY-MM-DD HH:mm",
                            dark: unref(isDarkMode),
                            format24h: true
                          }, {
                            default: withCtx(() => _cache[7] || (_cache[7] = [
                              createTextVNode(" Set start time ")
                            ])),
                            _: 1
                          }, 8, ["modelValue", "dark"])) : createCommentVNode("", true),
                          fTimeEndProxy.value && endDateSet.value ? (openBlock(), createBlock(QTime_default, {
                            key: 1,
                            range: "",
                            modelValue: fTimeEndProxy.value,
                            "onUpdate:modelValue": [
                              _cache[2] || (_cache[2] = ($event) => fTimeEndProxy.value = $event),
                              updateEndTime
                            ],
                            mask: "YYYY-MM-DD HH:mm",
                            dark: unref(isDarkMode),
                            format24h: true
                          }, {
                            default: withCtx(() => _cache[8] || (_cache[8] = [
                              createTextVNode(" Set end time ")
                            ])),
                            _: 1
                          }, 8, ["modelValue", "dark"])) : createCommentVNode("", true)
                        ])
                      ]),
                      _: 1
                    })
                  ]),
                  _: 1
                }),
                fDateRange.value ? (openBlock(), createElementBlock("div", _hoisted_6$1, [
                  createBaseVNode("div", _hoisted_7$1, [
                    createBaseVNode("span", _hoisted_8$1, [
                      createTextVNode(toDisplayString(isSingleDay.value ? unref(formatDatetime)(fDateRange.value, true, false) : unref(formatDatetime)(fDateRange.value.from, true, false)) + " ", 1),
                      filterTimeStart.value ? (openBlock(), createElementBlock("span", _hoisted_9$1, toDisplayString(unref(formatDatetime)(vTimeStartProxy.value ?? 0, false, true, false, unref(appUseUtc))), 1)) : createCommentVNode("", true)
                    ]),
                    !isSingleDay.value ? (openBlock(), createElementBlock("span", _hoisted_10$1, " to ")) : createCommentVNode("", true)
                  ]),
                  !isSingleDay.value ? (openBlock(), createElementBlock("div", _hoisted_11$1, [
                    createTextVNode(toDisplayString(unref(formatDatetime)(fDateRange.value.to, true, false)) + " ", 1),
                    filterTimeEnd.value ? (openBlock(), createElementBlock("span", _hoisted_12$1, toDisplayString(unref(formatDatetime)(vTimeEndProxy.value ?? 0, false, true, false, unref(appUseUtc))), 1)) : createCommentVNode("", true)
                  ])) : createCommentVNode("", true)
                ])) : createCommentVNode("", true)
              ])
            ]),
            createBaseVNode("div", _hoisted_13$1, [
              createVNode(GridInput, {
                "input-text": fInputMin.value,
                "onUpdate:inputText": [
                  _cache[3] || (_cache[3] = ($event) => fInputMin.value = $event),
                  validateAdaMinInput
                ],
                class: "col-span-12 sm:col-span-6 cc-text-sm",
                label: unref(t)("wallet.transactions.filter.amount.label") + " " + unref(t)("wallet.transactions.filter.amount.from"),
                "input-hint": "",
                autocomplete: "off",
                "input-id": "inputAdaMin",
                "input-type": "text",
                currency: "",
                "decimal-separator": decimalSeparator.value,
                "group-separator": groupSeparator.value
              }, {
                "icon-prepend": withCtx(() => [
                  createBaseVNode("span", _hoisted_14$1, toDisplayString(unref(adaSymbol)), 1)
                ]),
                _: 1
              }, 8, ["input-text", "label", "decimal-separator", "group-separator"]),
              createVNode(GridInput, {
                "input-text": fInputMax.value,
                "onUpdate:inputText": [
                  _cache[4] || (_cache[4] = ($event) => fInputMax.value = $event),
                  validateAdaMaxInput
                ],
                class: "col-span-12 sm:col-span-6 cc-text-sm mb-2",
                label: unref(t)("wallet.transactions.filter.amount.to"),
                "input-hint": "",
                autocomplete: "off",
                "input-id": "inputAdaMax",
                "input-type": "text",
                currency: "",
                "decimal-separator": decimalSeparator.value,
                "group-separator": groupSeparator.value
              }, {
                "icon-prepend": withCtx(() => [
                  createBaseVNode("span", _hoisted_15$1, toDisplayString(unref(adaSymbol)), 1)
                ]),
                _: 1
              }, 8, ["input-text", "label", "decimal-separator", "group-separator"])
            ]),
            createVNode(GridInput, {
              "input-text": fSearchInput.value,
              "onUpdate:inputText": [
                _cache[5] || (_cache[5] = ($event) => fSearchInput.value = $event),
                _cache[6] || (_cache[6] = ($event) => fSearchInput.value = $event)
              ],
              class: "col-span-12 mb-2",
              label: unref(t)("wallet.transactions.filter.search.label"),
              "input-info": unref(t)("wallet.transactions.filter.search.info"),
              "input-hint": unref(t)("wallet.transactions.filter.search.hint"),
              autofocus: "",
              autocomplete: "off",
              "input-id": "searchTx",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              _: 1
            }, 8, ["input-text", "label", "input-info", "input-hint"]),
            filterError.value ? (openBlock(), createElementBlock("div", _hoisted_16$1, [
              createVNode(IconError, { class: "w-7 flex-none mr-2" }),
              createVNode(_sfc_main$4, { text: filterError.value }, null, 8, ["text"])
            ])) : createCommentVNode("", true)
          ]),
          _: 1
        }, 8, ["reset-button-label", "submit-button-label"]),
        needFullSync.value ? (openBlock(), createElementBlock("div", _hoisted_17, [
          createVNode(IconWarning, { class: "w-7 flex-none mr-2" }),
          createBaseVNode("div", _hoisted_18, [
            createBaseVNode("div", _hoisted_19, [
              createBaseVNode("span", null, toDisplayString(unref(t)("wallet.transactions.filter.syncinfo_line1")), 1),
              unref(isHistorySyncEnabled) ? (openBlock(), createElementBlock("div", _hoisted_20, [
                _cache[9] || (_cache[9] = createBaseVNode("span", { class: "ml-1" }, "(", -1)),
                createBaseVNode("span", _hoisted_21, toDisplayString(unref(loadedTxCnt)), 1),
                _cache[10] || (_cache[10] = createBaseVNode("span", { class: "ml-0.5 cc-addr" }, "/", -1)),
                createBaseVNode("span", _hoisted_22, toDisplayString(unref(totalTxCnt)), 1),
                _cache[11] || (_cache[11] = createBaseVNode("span", { class: "ml-0.5" }, ").", -1))
              ])) : createCommentVNode("", true)
            ]),
            createBaseVNode("div", null, toDisplayString(unref(t)("wallet.transactions.filter.syncinfo_line2")), 1),
            !unref(isHistorySyncEnabled) ? (openBlock(), createElementBlock("div", _hoisted_23, toDisplayString(unref(t)("wallet.transactions.filter.autosync")), 1)) : createCommentVNode("", true)
          ])
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1 = { class: "cc-page-wallet cc-text-sz" };
const _hoisted_2 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_3 = { class: "flex flex-col cc-text-sz" };
const _hoisted_4 = { class: "m-2 sm:m-4" };
const _hoisted_5 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_6 = { class: "flex flex-col cc-text-sz" };
const _hoisted_7 = { class: "m-2 sm:m-4" };
const _hoisted_8 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 gap-2"
};
const _hoisted_9 = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_10 = { class: "col-span-8 flex flex-col" };
const _hoisted_11 = {
  key: 0,
  class: "flex flex-row"
};
const _hoisted_12 = {
  key: 1,
  class: "flex flex-row"
};
const _hoisted_13 = { class: "col-span-4" };
const _hoisted_14 = { class: "col-span-12 flex justify-center" };
const _hoisted_15 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_16 = { class: "col-span-12 flex justify-center" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Transactions",
  setup(__props) {
    useQuasar();
    const { it } = useTranslation();
    const { tabId } = useTabId();
    const {
      selectedAccountId,
      appAccount,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const isHistorySyncEnabled = accountSettings.isHistorySyncEnabled;
    const isManualSyncEnabled = accountSettings.isManualSyncEnabled;
    const expandResult = computed(() => hasSearchConfig.value && txListPage.value.length === 1);
    const isSyncingHistory = computed(() => !isManualSyncEnabled.value && isHistorySyncEnabled.value && numTxTotal.value !== numTxLoaded.value);
    onErrorCaptured((e) => {
      console.error("Transactions: onErrorCaptured", e);
      return true;
    });
    const pendingTxList = getPendingTxList();
    const pendingTxBalanceList = ref([]);
    const pendingMap = {};
    const showPagination = computed(() => numTxTotal.value > numItemsPerPage.value);
    const onTxFilterUpdate = (config) => searchTxList(config);
    const onTxFilterReset = () => searchTxList(null);
    async function checkPendingTx() {
      const list = [];
      if (!accountData.value) {
        pendingTxBalanceList.value = list;
        return;
      }
      pendingTxList.value.sort((a, b) => b.time - a.time);
      for (const pendingTx of pendingTxList.value) {
        pendingMap[pendingTx.hash] = pendingTx;
        const txBalance = await getSendITxBalance(accountData.value.state.networkId, accountData.value.account.id, pendingTx);
        if (txBalance && !isZero(txBalance.coin)) {
          list.push(txBalance);
        }
      }
      pendingTxBalanceList.value = list;
    }
    const showModal = ref(false);
    const showFilters = ref(false);
    const { toggleExportMenu } = useExportMenuOpen();
    const onClose = () => {
      showModal.value = false;
    };
    const openExport = () => {
      showModal.value = true;
      toggleExportMenu();
    };
    const onDelNote = () => {
      throw new Error("Not implemented");
    };
    const onAddNote = () => {
      throw new Error("Not implemented");
    };
    watch(pendingTxList, () => {
      checkPendingTx();
    });
    watch(accountData, () => {
      checkPendingTx();
    }, { immediate: true });
    const filterByTabId = () => {
      var _a;
      if (((_a = tabId.value) == null ? void 0 : _a.length) === 64) {
        searchTxList({ searchStr: tabId.value, coinHigh: null, coinLow: null, slotEnd: null, slotStart: null });
      }
    };
    onMounted(async () => {
      setTimeout(() => {
        filterByTabId();
      }, 250);
    });
    watch(tabId, (value, oldValue) => {
      filterByTabId();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_2, [
              createBaseVNode("div", _hoisted_3, [
                createVNode(_sfc_main$3, {
                  label: unref(it)("preferences.exports.transactions.modalHeader"),
                  "do-capitalize": ""
                }, null, 8, ["label"]),
                createVNode(_sfc_main$4, {
                  text: unref(it)("preferences.exports.transactions.modalSubHeader")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_4, [
              createVNode(_sfc_main$2)
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        showFilters.value ? (openBlock(), createBlock(Modal, {
          key: 1,
          narrow: "",
          onClose: _cache[0] || (_cache[0] = ($event) => showFilters.value = false)
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_5, [
              createBaseVNode("div", _hoisted_6, [
                createVNode(_sfc_main$3, {
                  label: unref(it)("wallet.transactions.filter.headline"),
                  "do-capitalize": ""
                }, null, 8, ["label"]),
                createVNode(_sfc_main$4, {
                  text: unref(it)("wallet.transactions.filter.caption")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_7, [
              createVNode(_sfc_main$1, {
                onSubmit: onTxFilterUpdate,
                onReset: onTxFilterReset
              })
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        createVNode(Transition, { name: "fade" }, {
          default: withCtx(() => [
            pendingTxBalanceList.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_8, [
              createVNode(_sfc_main$3, {
                label: unref(it)("wallet.transactions.history.pending.headline")
              }, null, 8, ["label"]),
              createVNode(_sfc_main$4, {
                text: pendingTxBalanceList.value.length + " " + unref(it)("wallet.transactions.history.pending.caption"),
                class: "truncate"
              }, null, 8, ["text"]),
              pendingTxBalanceList.value.length > 0 ? (openBlock(), createBlock(GridSpace, {
                key: 0,
                hr: ""
              })) : createCommentVNode("", true),
              (openBlock(true), createElementBlock(Fragment, null, renderList(pendingTxBalanceList.value, (txBalance, index) => {
                return openBlock(), createBlock(_sfc_main$6, {
                  key: txBalance.hash + Math.random() * 99999,
                  "tx-balance": txBalance,
                  tx: pendingMap[txBalance.hash],
                  "account-id": unref(selectedAccountId),
                  "pending-tx": "",
                  onAddNote,
                  onDeleteNote: onDelNote
                }, null, 8, ["tx-balance", "tx", "account-id"]);
              }), 128))
            ])) : createCommentVNode("", true)
          ]),
          _: 1
        }),
        createBaseVNode("div", _hoisted_9, [
          createBaseVNode("div", _hoisted_10, [
            createVNode(_sfc_main$3, {
              label: unref(it)("wallet.transactions.history.headline"),
              class: "col-span-1"
            }, null, 8, ["label"]),
            !unref(hasSearchConfig) ? (openBlock(), createElementBlock("div", _hoisted_11, [
              createVNode(_sfc_main$4, {
                text: unref(numTxTotal) + " " + unref(it)("wallet.transactions.history.caption"),
                class: "truncate"
              }, null, 8, ["text"]),
              unref(numTxLoaded) !== unref(numTxTotal) ? (openBlock(), createBlock(_sfc_main$4, {
                key: 0,
                text: "(" + unref(numTxLoaded) + " " + unref(it)("wallet.transactions.history.loaded") + ")",
                class: normalizeClass(["truncate", { "animate-pulse": isSyncingHistory.value }])
              }, null, 8, ["text", "class"])) : createCommentVNode("", true)
            ])) : (openBlock(), createElementBlock("div", _hoisted_12, [
              createVNode(_sfc_main$4, {
                text: unref(numTxTotal) + " " + unref(it)("wallet.transactions.filtered") + " ",
                class: "truncate"
              }, null, 8, ["text"]),
              unref(numTxTotal) === unref(numMaxSearchResults) ? (openBlock(), createBlock(_sfc_main$4, {
                key: 0,
                text: unref(it)("wallet.transactions.filtermax"),
                class: "ml-1 italic truncate"
              }, null, 8, ["text"])) : createCommentVNode("", true)
            ]))
          ]),
          createBaseVNode("div", _hoisted_13, [
            createBaseVNode("div", {
              class: normalizeClass(["flex justify-end items-start gap-2", unref(hasSearchConfig) && isSyncingHistory.value ? "row-span-4" : unref(hasSearchConfig) || isSyncingHistory.value ? "row-span-3" : "row-span-2"])
            }, [
              createVNode(GridButtonSecondary, {
                class: "px-4",
                icon: unref(hasSearchConfig) ? "mdi mdi-close-circle-outline" : "",
                "icon-clickable": "",
                label: unref(it)("wallet.transactions.filter.button"),
                onIconClick: onTxFilterReset,
                onClick: _cache[1] || (_cache[1] = withModifiers(($event) => showFilters.value = !showFilters.value, ["stop"]))
              }, null, 8, ["icon", "label"]),
              createBaseVNode("div", {
                class: "material-icons material-icons-outlined cursor-pointer button z-50 cc-rounded items-center text-xs sm:text-sm cc-tabs-button text-center no-underline px-3 py-2",
                onClick: openExport
              }, "download")
            ], 2)
          ])
        ]),
        showPagination.value ? (openBlock(), createBlock(GridSpace, {
          key: 2,
          hr: ""
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_14, [
          showPagination.value ? (openBlock(), createBlock(QPagination_default, {
            key: 0,
            modelValue: unref(currentPage),
            "onUpdate:modelValue": _cache[2] || (_cache[2] = ($event) => isRef(currentPage) ? currentPage.value = $event : null),
            max: unref(numMaxPages),
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
        createVNode(GridSpace, { hr: "" }),
        unref(isUpdating) && unref(txListPage).length === 0 ? (openBlock(), createBlock(_sfc_main$7, {
          key: 3,
          active: unref(isUpdating)
        }, null, 8, ["active"])) : (openBlock(), createElementBlock(Fragment, { key: 4 }, [
          unref(selectedAccountId) ? (openBlock(), createElementBlock("div", _hoisted_15, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(txListPage), (txBalance) => {
              return openBlock(), createBlock(_sfc_main$6, {
                key: txBalance.hash + Math.random() * 99999,
                "account-id": unref(selectedAccountId),
                "tx-balance": txBalance,
                "is-open": expandResult.value
              }, null, 8, ["account-id", "tx-balance", "is-open"]);
            }), 128))
          ])) : createCommentVNode("", true)
        ], 64)),
        createBaseVNode("div", _hoisted_16, [
          showPagination.value ? (openBlock(), createBlock(QPagination_default, {
            key: 0,
            modelValue: unref(currentPage),
            "onUpdate:modelValue": _cache[3] || (_cache[3] = ($event) => isRef(currentPage) ? currentPage.value = $event : null),
            max: unref(numMaxPages),
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
      ]);
    };
  }
});
export {
  _sfc_main as default
};
