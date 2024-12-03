import { i7 as toB64Buffer, ew as cryptoBrowserifyExports, dq as Buffer$1, i8 as toB64String, es as getRequestData, et as ApiRequestType, eu as ErrorSync, ev as DEFAULT_ACCOUNT_ID, d as defineComponent, z as ref, D as watch, bT as json, i9 as getPlutusHVB, ct as onErrorCaptured, o as openBlock, c as createElementBlock, q as createVNode, u as unref, e as createBaseVNode, t as toDisplayString, j as createCommentVNode, f as computed, ia as useWindowSize, C as onMounted, H as Fragment, I as renderList, a as createBlock, aH as QPagination_default, ib as useDetailedTxInfo, aI as useGuard, h as withCtx, i as createTextVNode, bi as getUtxoHash, B as useFormatter, bs as useWitnesses, b3 as toHexString, eI as getAddressCredentials, ic as getDeposit, b as withModifiers, n as normalizeClass, eW as compare, hv as formatAssetName, c6 as getAssetIdBech32, eP as CertificateTypes, id as CertificateKind, ie as getPoolAddressFromKeyHash, dm as getRewardAddressFromCred, K as networkId, gM as getDRepAddressFromKeyHash, gN as getDRepAddressFromKeyHashOld, gh as getMetadataType, eQ as createJsonFromCborJson, Q as QSpinnerDots_default, F as withDirectives, ge as vModelText, a5 as toRefs, ig as getTxBalance, ae as useSelectedAccount, a2 as now, ih as saveTxNote, a7 as useQuasar, aG as onUnmounted, eL as createIUtxo, eV as createIUtxoFromIUtxoDetails, ga as getTransactionFromCbor, gk as cslToJson, i4 as freeCSLObjects, ii as loadUnknownUtxos, ij as getAllInputUtxoHashList, ik as getEpochFromSlot, O as chainTip, aY as checkEpochParams, il as syncEpochParams, im as PlutusScripts, io as jsonToCsl, b0 as safeFreeCSLObject, ip as PlutusScript, iq as toHexBuffer, hr as round, c_ as add, cZ as multiply, ir as isOnChainState, is as isInvalidState, it as isSubmittedState, iu as isSignedState, iv as timestamp, iw as getCalculatedChainTip, bm as dispatchSignal, ix as doUpdatePendingTxStatus, bh as getTimestampFromSlot, iy as getAddressesByRefId, iz as getContractMappingByAddresses, aW as addSignalListener, iA as onInterval60s, aX as removeSignalListener, bk as QSpinner_default, J as vShow, cf as getRandomId, iB as decryptedMsgMap, iC as saveDecryptedMsg, P as normalizeStyle, iD as delDecryptedMsg, iE as doRemovePendingTx, i6 as submitTx } from "./index.js";
import { S, c as isMilkomedaTx, d as getNetworkExplorerUrlFromItx, b as networkMetadataAddressKey, e as getJsonValue } from "./vue-json-pretty.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$h } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$r } from "./GridTxListEntryBalance.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$j, u as useReportDetails } from "./GridTxListUtxoListBadges.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import { _ as _sfc_main$p } from "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$l } from "./GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$g } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$i } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$k } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$m } from "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$o } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$n } from "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$q } from "./AccessPasswordInputModal.vue_vue_type_script_setup_true_lang.js";
const HASH = "SHA-256";
const ITERATRIONS = 1e4;
const DERIVIATION_KEY_LENGTH = 48;
const IV_LENGTH = 16;
const KEY_LENGTH = 32;
const TEXT_ENCODER = new TextEncoder();
const TEXT_DECODER = new TextDecoder("utf-8");
const DEFAULT_MSG_PASSWORD = "cardano";
const encryptMessage = async (msg, password, enc = "basic") => {
  if (enc !== "basic") {
    throw new Error("Unsupported decryption type: " + enc);
  }
  try {
    let salt8;
    if (typeof self !== "undefined") {
      salt8 = self.crypto.getRandomValues(new Uint8Array(8));
    } else {
      salt8 = cryptoBrowserifyExports.webcrypto.getRandomValues(new Uint8Array(8));
    }
    const derivation = await getDerivation(salt8, password);
    const keyObject = await getKey(derivation);
    const encryptedObject = await encrypt(JSON.stringify(msg), keyObject);
    const encObjectU8 = Uint8Array.from(Buffer$1.from(encryptedObject));
    const prefix = TEXT_ENCODER.encode("Salted__");
    const prefixedEncObject = new Uint8Array(prefix.length + salt8.length + encObjectU8.length);
    prefixedEncObject.set(prefix);
    prefixedEncObject.set(salt8, prefix.length);
    prefixedEncObject.set(encObjectU8, prefix.length + salt8.length);
    return toB64String(prefixedEncObject);
  } catch (e) {
    throw new Error("Failed to encrypt message: " + (e.message ?? e));
  }
};
const decryptMessage = async (msg, password, enc = "basic") => {
  if (enc !== "basic") {
    throw new Error("Unsupported decryption type: " + enc);
  }
  try {
    const derivation = await getDerivation(toB64Buffer(msg).slice(8, 16), password);
    const keyObject = await getKey(derivation);
    let decryptedObject = JSON.parse(await decrypt(toB64Buffer(msg).slice(16), keyObject));
    if (typeof decryptedObject === "string") {
      decryptedObject = decryptedObject.split("\n");
    }
    return decryptedObject;
  } catch (e) {
    throw new Error("Failed to decrypt message: " + (e.message ?? e));
  }
};
async function getDerivation(salt, password) {
  const passwordBuffer = TEXT_ENCODER.encode(password);
  const importedKey = await crypto.subtle.importKey("raw", passwordBuffer, "PBKDF2", false, ["deriveBits"]);
  const params = {
    name: "PBKDF2",
    hash: HASH,
    salt,
    iterations: ITERATRIONS
  };
  return await crypto.subtle.deriveBits(params, importedKey, DERIVIATION_KEY_LENGTH * 8);
}
async function getKey(derivation) {
  const derivedKey = derivation.slice(0, KEY_LENGTH);
  const iv = derivation.slice(KEY_LENGTH, KEY_LENGTH + IV_LENGTH);
  const importedEncryptionKey = await crypto.subtle.importKey("raw", derivedKey, { name: "AES-CBC" }, false, ["encrypt", "decrypt"]);
  return {
    key: importedEncryptionKey,
    iv
  };
}
async function encrypt(text, keyObject) {
  const textBuffer = TEXT_ENCODER.encode(text);
  return await crypto.subtle.encrypt({ name: "AES-CBC", iv: keyObject.iv }, keyObject.key, textBuffer);
}
async function decrypt(encryptedText, keyObject) {
  const decryptedText = await crypto.subtle.decrypt({ name: "AES-CBC", iv: keyObject.iv }, keyObject.key, encryptedText);
  return TEXT_DECODER.decode(decryptedText);
}
const loadTxCbor = async (networkId2, accountId, txHash) => {
  if (!txHash) {
    return null;
  }
  return loadTxCborList(networkId2, accountId, [txHash]);
};
const loadTxCborList = async (networkId2, accountId, txHashList) => {
  if (!accountId) {
    accountId = DEFAULT_ACCOUNT_ID;
  }
  return getRequestData()(
    networkId2,
    accountId,
    ApiRequestType.syncTxCbor,
    ErrorSync.loadTxCborList,
    {
      id: accountId,
      txHashList
    },
    async (data) => {
      if (!data.txCborList) {
        throw "missingTxCborList";
      }
      return data.txCborList;
    }
  );
};
const loadTxByron = async (networkId2, accountId, txHash) => {
  if (!txHash) {
    return null;
  }
  return loadTxByronList(networkId2, accountId, [txHash]);
};
const loadTxByronList = async (networkId2, accountId, txHashList) => {
  if (txHashList.length === 0) {
    return [];
  }
  if (!accountId) {
    accountId = DEFAULT_ACCOUNT_ID;
  }
  return getRequestData()(
    networkId2,
    accountId,
    ApiRequestType.syncTxByron,
    ErrorSync.loadTxByronList,
    {
      id: accountId,
      txHashList
    },
    async (data) => {
      return data.txByronList ?? [];
    }
  );
};
const createTransactionJSONFromITxByron = (ref2) => {
  const cslTx = {
    body: {
      fee: ref2.f,
      inputs: [],
      outputs: []
    },
    is_valid: true,
    witness_set: {}
  };
  for (const input of ref2.il) {
    cslTx.body.inputs.push({
      transaction_id: input.h,
      index: input.i
    });
  }
  for (const output of ref2.ol) {
    cslTx.body.outputs.push({
      address: output.a.b,
      amount: {
        coin: output.o
      }
    });
  }
  return cslTx;
};
const _hoisted_1$f = {
  key: 0,
  class: "relative w-full max-w-full"
};
const _hoisted_2$f = { class: "relative w-full max-w-full flex flex-col flex-nowrap items-start cc-text-sm" };
const _hoisted_3$e = { class: "relative w-full max-w-full flex flex-row flex-nowrap cc-text-xs" };
const _hoisted_4$e = { class: "pr-1 cc-text-semi-bold whitespace-nowrap min-w-9" };
const _hoisted_5$c = { class: "w-5 align-text-top" };
const _hoisted_6$9 = { class: "w-full max-w-full cc-addr truncate overflow-hidden" };
const _hoisted_7$9 = {
  key: 0,
  class: "relative w-full max-w-full flex flex-row flex-nowrap cc-text-xs"
};
const _hoisted_8$9 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap min-w-9" };
const _hoisted_9$8 = { class: "w-5 align-text-top" };
const _hoisted_10$8 = { class: "w-full max-w-full cc-addr truncate overflow-hidden" };
const _hoisted_11$8 = {
  key: 1,
  class: "relative w-full max-w-full flex flex-row flex-nowrap cc-text-xs"
};
const _hoisted_12$7 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap min-w-9" };
const _hoisted_13$6 = { class: "w-5 align-text-top" };
const _hoisted_14$5 = { class: "w-full font-mono" };
const _sfc_main$f = /* @__PURE__ */ defineComponent({
  __name: "GridTxListDatum",
  props: {
    output: { type: Object, required: true }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const datum = ref(null);
    watch(() => props.output.plutus_data, () => {
      if (!props.output.plutus_data) {
        return null;
      }
      const data = json(props.output.plutus_data);
      datum.value = getPlutusHVB(data);
    }, { immediate: true });
    onErrorCaptured((e) => {
      console.error("GridTxListDatum: onErrorCaptured", e);
      return true;
    });
    return (_ctx, _cache) => {
      return datum.value ? (openBlock(), createElementBlock("div", _hoisted_1$f, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full opacity-50",
          label: unref(t)("wallet.transactions.header.datum.label." + (!datum.value.value ? "hash" : "inline")),
          "align-label": "left"
        }, null, 8, ["label"]),
        createBaseVNode("div", _hoisted_2$f, [
          createBaseVNode("div", _hoisted_3$e, [
            createBaseVNode("div", _hoisted_4$e, toDisplayString(unref(t)("wallet.transactions.header.datum.hash")), 1),
            createBaseVNode("div", _hoisted_5$c, [
              createVNode(_sfc_main$g, {
                "label-hover": unref(t)("wallet.transactions.button.copy.hash.hover"),
                "notification-text": unref(t)("wallet.transactions.button.copy.hash.notify"),
                "copy-text": datum.value.hash,
                class: "ml-1 inline-flex items-center justify-center"
              }, null, 8, ["label-hover", "notification-text", "copy-text"])
            ]),
            createBaseVNode("div", _hoisted_6$9, toDisplayString(datum.value.hash), 1)
          ]),
          datum.value.bytes ? (openBlock(), createElementBlock("div", _hoisted_7$9, [
            createBaseVNode("div", _hoisted_8$9, toDisplayString(unref(t)("wallet.transactions.header.datum.bytes")), 1),
            createBaseVNode("div", _hoisted_9$8, [
              createVNode(_sfc_main$g, {
                "label-hover": unref(t)("wallet.transactions.button.copy.bytes.hover"),
                "notification-text": unref(t)("wallet.transactions.button.copy.bytes.notify"),
                "copy-text": JSON.stringify(datum.value.bytes),
                class: "ml-1 inline-flex items-center justify-center"
              }, null, 8, ["label-hover", "notification-text", "copy-text"])
            ]),
            createBaseVNode("div", _hoisted_10$8, toDisplayString(JSON.stringify(datum.value.bytes)), 1)
          ])) : createCommentVNode("", true),
          datum.value.value ? (openBlock(), createElementBlock("div", _hoisted_11$8, [
            createBaseVNode("div", _hoisted_12$7, toDisplayString(unref(t)("wallet.transactions.header.datum.json")), 1),
            createBaseVNode("div", _hoisted_13$6, [
              createVNode(_sfc_main$g, {
                "label-hover": unref(t)("wallet.transactions.button.copy.datum.hover"),
                "notification-text": unref(t)("wallet.transactions.button.copy.datum.notify"),
                "copy-text": JSON.stringify(datum.value.value),
                class: "ml-1 inline-flex items-center justify-center"
              }, null, 8, ["label-hover", "notification-text", "copy-text"])
            ]),
            createBaseVNode("div", _hoisted_14$5, [
              createVNode(unref(S), {
                showLength: "",
                showDoubleQuotes: false,
                deep: 0,
                data: datum.value.value
              }, null, 8, ["data"])
            ])
          ])) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$e = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$e = { class: "relative w-full flex flex-row flex-nowrap items-start cc-text-sm" };
const _hoisted_3$d = { class: "w-5 align-text-top" };
const _hoisted_4$d = { class: "cc-addr truncate" };
const _sfc_main$e = /* @__PURE__ */ defineComponent({
  __name: "GridTxListReferenceScript",
  props: {
    output: { type: Object, required: true }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const nativeScriptRef = computed(() => {
      var _a;
      if (!((_a = props.output) == null ? void 0 : _a.script_ref)) {
        return null;
      }
      if ("NativeScript" in props.output.script_ref) {
        return JSON.stringify(props.output.script_ref.NativeScript);
      }
      return null;
    });
    const plutusScriptRef = computed(() => {
      var _a;
      if (!((_a = props.output) == null ? void 0 : _a.script_ref)) {
        return null;
      }
      if ("PlutusScript" in props.output.script_ref) {
        return JSON.stringify(props.output.script_ref.PlutusScript);
      }
      return null;
    });
    return (_ctx, _cache) => {
      return nativeScriptRef.value || plutusScriptRef.value ? (openBlock(), createElementBlock("div", _hoisted_1$e, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full opacity-50 mb-0.5",
          label: unref(t)("wallet.transactions.header.script.label." + (!nativeScriptRef.value ? "native" : "plutus")),
          "align-label": "left"
        }, null, 8, ["label"]),
        createBaseVNode("div", _hoisted_2$e, [
          createBaseVNode("div", _hoisted_3$d, [
            createVNode(_sfc_main$g, {
              "label-hover": unref(t)("wallet.transactions.button.copy.hash.hover"),
              "notification-text": unref(t)("wallet.transactions.button.copy.hash.notify"),
              "copy-text": nativeScriptRef.value || plutusScriptRef.value,
              class: "ml-1 inline-flex items-center justify-center"
            }, null, 8, ["label-hover", "notification-text", "copy-text"])
          ]),
          createBaseVNode("div", _hoisted_4$d, toDisplayString(nativeScriptRef.value || plutusScriptRef.value), 1)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$d = { class: "whitespace-nowrap cc-text-semi-bold mt-2" };
const _hoisted_2$d = { class: "w-full flex flex-row flex-nowrap items-start" };
const _hoisted_3$c = { key: 0 };
const _hoisted_4$c = {
  key: 1,
  class: "relative"
};
const _hoisted_5$b = { class: "w-full flex flex-row flex-nowrap justify-between items-start gap-1" };
const _hoisted_6$8 = { key: 0 };
const _hoisted_7$8 = { class: "cc-badge-red cc-none inline-flex" };
const _hoisted_8$8 = {
  key: 0,
  class: "w-full flex flex-row flex-nowrap items-start opacity-50 -mt-1"
};
const _hoisted_9$7 = { class: "w-full flex flex-col" };
const _hoisted_10$7 = { class: "w-full flex flex-row flex-nowrap items-start justify-between gap-1" };
const _hoisted_11$7 = { class: "cc-addr" };
const _hoisted_12$6 = {
  key: 1,
  class: "w-full flex flex-row flex-nowrap items-start opacity-50 -mt-1"
};
const _hoisted_13$5 = { class: "w-full flex flex-col" };
const _hoisted_14$4 = { class: "w-full flex flex-row flex-nowrap items-start justify-between gap-1" };
const _hoisted_15$4 = { class: "cc-addr" };
const _hoisted_16$4 = { class: "grow-1 w-full flex" };
const _hoisted_17$4 = { class: "relative max-w-full align-text-top justify-end flex-grow-1 flex-auto flex-grow-1" };
const _hoisted_18$4 = {
  key: 2,
  class: "grow-1 w-full flex flex-col flex-nowrap items-start"
};
const _hoisted_19$3 = { class: "flex flex-row flex-nowrap items-start gap-0.5" };
const _hoisted_20$3 = {
  key: 3,
  class: "grow-1 w-full flex gap-2"
};
const _hoisted_21$3 = {
  key: 1,
  class: "self-center mt-2"
};
const itemsOnPage = 10;
const _sfc_main$d = /* @__PURE__ */ defineComponent({
  __name: "GridTxListUtxoList",
  props: {
    label: { type: String },
    utxoList: { type: Object, required: true },
    accountId: { type: String, required: false, default: "" },
    txHash: { type: String, required: false, default: "" },
    isInput: { type: Boolean, required: false, default: false },
    witnessCheck: { type: Boolean, required: false, default: false },
    txViewer: { type: Boolean, required: false, default: false }
  },
  emits: ["scamAddressFound"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { width, height } = useWindowSize();
    const { showTxDetails } = useDetailedTxInfo();
    const { t } = useTranslation();
    const { truncateAddress } = useFormatter();
    const {
      isSignedUtxo,
      hasSpendRedeemer
    } = useWitnesses();
    const { isAddressOnBlockList } = useGuard();
    const currentPage = ref(1);
    const showPagination = computed(() => props.utxoList.length > itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const maxPages = computed(() => Math.ceil(props.utxoList.length / itemsOnPage));
    const utxoListPaged = computed(() => props.utxoList.slice(currentPageStart.value, currentPageStart.value + itemsOnPage));
    const isScam = ref(false);
    const scamAddresses = ref([]);
    const addrLength = computed(() => {
      if (showTxDetails.value) {
        return 999;
      }
      if (width.value >= 1460) {
        return 65;
      }
      if (width.value >= 1024) {
        const diff2 = width.value - 1024;
        return 35 + Math.floor(18 * (diff2 / (1460 - 1024) * 1.7));
      }
      if (width.value >= 640) {
        const diff2 = width.value - 640;
        return 30 + Math.floor(13 * (diff2 / (1024 - 640) * 2));
      }
      const diff = Math.max(width.value - 240, 0);
      return 19 + Math.floor(32 * (diff / (640 - 240) * 1.7));
    });
    watch(() => maxPages.value, (newValue) => newValue > 0 && newValue < currentPage.value ? currentPage.value = newValue : false);
    const getExplorerAddress = (address) => {
      const addrHex = toHexString(getAddressCredentials(address, null, true).addressBytes);
      return {
        bech32: address,
        hash: addrHex
      };
    };
    const watchSpam = async () => {
      for (let utxo of utxoListPaged.value) {
        let addressIsScam = await isAddressOnBlockList(utxo.output.address);
        if (addressIsScam) {
          isScam.value = true;
          scamAddresses.value.push(utxo.output.address);
          emit("scamAddressFound");
        } else {
          isScam.value = false;
        }
      }
    };
    watch(utxoListPaged, async () => {
      await watchSpam();
    });
    onMounted(async () => {
      await watchSpam();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", _hoisted_1$d, toDisplayString(__props.utxoList.length + " " + __props.label), 1),
        (openBlock(true), createElementBlock(Fragment, null, renderList(utxoListPaged.value, (utxo, index) => {
          return openBlock(), createElementBlock("div", {
            class: "flex flex-col flex-nowrap items-start cc-bg-txdetails gap-1.5 mt-1 px-2 py-2",
            key: index
          }, [
            createBaseVNode("div", _hoisted_2$d, [
              createBaseVNode("div", null, [
                __props.witnessCheck && __props.isInput && unref(isSignedUtxo)(utxo) ? (openBlock(), createElementBlock("div", _hoisted_3$c, [
                  _cache[2] || (_cache[2] = createBaseVNode("i", { class: "mdi mdi-lock-open-check mr-1 cc-text-green" }, null, -1)),
                  createVNode(_sfc_main$h, {
                    anchor: "bottom middle",
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => _cache[1] || (_cache[1] = [
                      createTextVNode(toDisplayString("Witness included"))
                    ])),
                    _: 1
                  })
                ])) : __props.witnessCheck && __props.isInput && unref(hasSpendRedeemer)(utxo.input) ? (openBlock(), createElementBlock("div", _hoisted_4$c, [
                  _cache[4] || (_cache[4] = createBaseVNode("i", { class: "mdi mdi-lock-open-check mr-1 cc-text-green" }, null, -1)),
                  createVNode(_sfc_main$h, {
                    anchor: "bottom middle",
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => _cache[3] || (_cache[3] = [
                      createTextVNode(toDisplayString("Witnessed by contract redeemer"))
                    ])),
                    _: 1
                  })
                ])) : createCommentVNode("", true)
              ]),
              createBaseVNode("div", _hoisted_5$b, [
                createVNode(_sfc_main$i, {
                  subject: getExplorerAddress(utxo.output.address),
                  type: "address",
                  label: unref(truncateAddress)(utxo.output.address, addrLength.value, null),
                  "label-c-s-s": "cc-addr cc-text-color-caption mr-0"
                }, null, 8, ["subject", "label"]),
                createVNode(_sfc_main$g, {
                  "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                  "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                  "copy-text": utxo.output.address,
                  class: "inline-flex items-center justify-center"
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                scamAddresses.value.includes(utxo.output.address) ? (openBlock(), createElementBlock("div", _hoisted_6$8, [
                  createBaseVNode("div", _hoisted_7$8, [
                    createTextVNode(toDisplayString(unref(t)("common.scam.token.label")) + " ", 1),
                    createVNode(_sfc_main$h, {
                      anchor: "bottom middle",
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("common.scam.address.hover")), 1)
                      ]),
                      _: 1
                    })
                  ])
                ])) : createCommentVNode("", true)
              ])
            ]),
            (__props.txViewer || unref(showTxDetails)) && utxo.pc ? (openBlock(), createElementBlock("div", _hoisted_8$8, [
              createBaseVNode("div", _hoisted_9$7, [
                _cache[5] || (_cache[5] = createBaseVNode("div", { class: "cc-addr text-bold" }, "Payment Cred:", -1)),
                createBaseVNode("div", _hoisted_10$7, [
                  createBaseVNode("div", _hoisted_11$7, toDisplayString(utxo.pc), 1),
                  createVNode(_sfc_main$g, {
                    "label-hover": unref(t)("wallet.transactions.button.copy.cred.hover"),
                    "notification-text": unref(t)("wallet.transactions.button.copy.cred.notify"),
                    "copy-text": utxo.pc.toString(),
                    class: "inline-flex items-center justify-center"
                  }, null, 8, ["label-hover", "notification-text", "copy-text"])
                ])
              ])
            ])) : createCommentVNode("", true),
            (__props.txViewer || unref(showTxDetails)) && utxo.sc ? (openBlock(), createElementBlock("div", _hoisted_12$6, [
              createBaseVNode("div", _hoisted_13$5, [
                _cache[6] || (_cache[6] = createBaseVNode("div", { class: "cc-addr text-bold" }, "Stake Cred:", -1)),
                createBaseVNode("div", _hoisted_14$4, [
                  createBaseVNode("div", _hoisted_15$4, toDisplayString(utxo.sc), 1),
                  createVNode(_sfc_main$g, {
                    "label-hover": unref(t)("wallet.transactions.button.copy.cred.hover"),
                    "notification-text": unref(t)("wallet.transactions.button.copy.cred.notify"),
                    "copy-text": utxo.sc.toString(),
                    class: "inline-flex items-center justify-center"
                  }, null, 8, ["label-hover", "notification-text", "copy-text"])
                ])
              ])
            ])) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_16$4, [
              createVNode(_sfc_main$j, {
                utxo,
                "tx-viewer": __props.txViewer,
                "account-id": __props.accountId,
                "tx-hash": __props.txHash
              }, null, 8, ["utxo", "tx-viewer", "account-id", "tx-hash"]),
              createBaseVNode("div", _hoisted_17$4, [
                createVNode(_sfc_main$k, {
                  amount: utxo.output.amount.coin,
                  "text-c-s-s": "w-full justify-end"
                }, null, 8, ["amount"]),
                createVNode(_sfc_main$l, {
                  balance: utxo.output.amount
                }, null, 8, ["balance"])
              ])
            ]),
            __props.isInput && unref(showTxDetails) ? (openBlock(), createElementBlock("div", _hoisted_18$4, [
              createVNode(GridSpace, {
                hr: "",
                class: "w-full opacity-50",
                label: "txhash # index",
                "align-label": "left"
              }),
              createBaseVNode("div", _hoisted_19$3, [
                createVNode(_sfc_main$g, {
                  "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                  "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                  "copy-text": unref(getUtxoHash)(utxo.input),
                  class: "inline-flex items-center justify-center"
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createVNode(_sfc_main$i, {
                  subject: utxo.input.transaction_id,
                  type: "transaction",
                  label: unref(getUtxoHash)(utxo.input),
                  "label-c-s-s": "cc-addr cc-text-color-caption"
                }, null, 8, ["subject", "label"])
              ])
            ])) : createCommentVNode("", true),
            unref(showTxDetails) && (utxo.output.plutus_data || utxo.output.script_ref) ? (openBlock(), createElementBlock("div", _hoisted_20$3, [
              utxo.output.plutus_data ? (openBlock(), createBlock(_sfc_main$f, {
                key: 0,
                output: utxo.output
              }, null, 8, ["output"])) : createCommentVNode("", true),
              utxo.output.script_ref ? (openBlock(), createBlock(_sfc_main$e, {
                key: 1,
                output: utxo.output
              }, null, 8, ["output"])) : createCommentVNode("", true)
            ])) : createCommentVNode("", true)
          ]);
        }), 128)),
        showPagination.value ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          class: "w-full mt-2"
        })) : createCommentVNode("", true),
        showPagination.value ? (openBlock(), createElementBlock("div", _hoisted_21$3, [
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
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$c = { class: "w-full flex flex-col xs:flex-row flex-nowrap items-start justify-between cc-text-sm gap-1 xs:gap-2" };
const _hoisted_2$c = {
  key: 0,
  class: "flex-col h-full"
};
const _hoisted_3$b = {
  key: 0,
  class: "whitespace-nowrap"
};
const _hoisted_4$b = { class: "cc-text-semi-bold" };
const _hoisted_5$a = {
  key: 2,
  class: "cc-addr pt-1"
};
const _hoisted_6$7 = {
  key: 1,
  class: "flex flex-row xs:flex-col justify-between xs:justify-start items-start w-full xs:w-auto h-full"
};
const _hoisted_7$7 = { class: "whitespace-nowrap" };
const _hoisted_8$7 = { class: "cc-text-semi-bold" };
const _hoisted_9$6 = {
  key: 2,
  class: "flex flex-row xs:flex-col justify-between xs:justify-start w-full xs:w-auto"
};
const _hoisted_10$6 = { class: "whitespace-nowrap" };
const _hoisted_11$6 = { class: "cc-text-semi-bold" };
const _hoisted_12$5 = { class: "justify-end flex-nowrap" };
const _hoisted_13$4 = {
  key: 3,
  class: "flex flex-row xs:flex-col justify-between xs:justify-start w-full xs:w-auto"
};
const _hoisted_14$3 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_15$3 = {
  key: 4,
  class: "flex flex-row xs:flex-col justify-between xs:justify-start w-full xs:w-auto"
};
const _hoisted_16$3 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_17$3 = { class: "flex flex-row xs:flex-col justify-between xs:justify-start w-full xs:w-auto" };
const _hoisted_18$3 = { class: "whitespace-nowrap cc-text-semi-bold text-right" };
const _sfc_main$c = /* @__PURE__ */ defineComponent({
  __name: "GridTxListHashBlockNoFee",
  props: {
    tx: { type: Object, required: true },
    inputUtxoList: { type: null, required: true },
    hash: { type: String, required: false, default: "" },
    blockNo: { type: Number, required: false, default: 0 },
    blochHash: { type: String, required: false, default: "" },
    stagingTx: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    var _a;
    const props = __props;
    const { t } = useTranslation();
    const deposit = ref("0");
    const donation = ref(((_a = props.tx) == null ? void 0 : _a.body.donation) ?? "0");
    const calculateDeposit = () => {
      deposit.value = getDeposit(props.tx, void 0, true);
    };
    watch(() => props.inputUtxoList, () => {
      var _a2, _b, _c, _d;
      if ((((_b = (_a2 = props.tx) == null ? void 0 : _a2.body.certs) == null ? void 0 : _b.length) ?? 0) > 0 && (((_d = (_c = props.tx) == null ? void 0 : _c.inputUtxoList) == null ? void 0 : _d.length) ?? 0) > 0) {
        calculateDeposit();
      }
    }, { deep: true });
    watch(() => props.tx, () => {
      var _a2, _b, _c, _d;
      if ((((_b = (_a2 = props.tx) == null ? void 0 : _a2.body.certs) == null ? void 0 : _b.length) ?? 0) > 0 && (((_d = (_c = props.tx) == null ? void 0 : _c.inputUtxoList) == null ? void 0 : _d.length) ?? 0) > 0) {
        calculateDeposit();
      }
    }, { deep: true });
    onMounted(() => {
      var _a2, _b, _c, _d;
      if ((((_b = (_a2 = props.tx) == null ? void 0 : _a2.body.certs) == null ? void 0 : _b.length) ?? 0) > 0 && (((_d = (_c = props.tx) == null ? void 0 : _c.inputUtxoList) == null ? void 0 : _d.length) ?? 0) > 0) {
        calculateDeposit();
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$c, [
        __props.hash ? (openBlock(), createElementBlock("div", _hoisted_2$c, [
          __props.hash ? (openBlock(), createElementBlock("div", _hoisted_3$b, [
            createBaseVNode("span", _hoisted_4$b, toDisplayString(unref(t)("wallet.transactions.header.txId")), 1),
            createVNode(_sfc_main$g, {
              "label-hover": unref(t)("wallet.transactions.button.copy.tx.hover"),
              "notification-text": unref(t)("wallet.transactions.button.copy.tx.notify"),
              "copy-text": __props.hash,
              class: "ml-1 inline-flex items-center justify-center"
            }, null, 8, ["label-hover", "notification-text", "copy-text"])
          ])) : createCommentVNode("", true),
          __props.hash && !__props.stagingTx ? (openBlock(), createBlock(_sfc_main$i, {
            key: 1,
            subject: __props.hash,
            type: "transaction",
            label: __props.hash,
            "label-c-s-s": "cc-addr hover:text-gray-500"
          }, null, 8, ["subject", "label"])) : (openBlock(), createElementBlock("div", _hoisted_5$a, toDisplayString(__props.hash), 1))
        ])) : createCommentVNode("", true),
        !__props.stagingTx && __props.blockNo > 0 ? (openBlock(), createElementBlock("div", _hoisted_6$7, [
          createBaseVNode("div", _hoisted_7$7, [
            createBaseVNode("span", _hoisted_8$7, toDisplayString(unref(t)("wallet.transactions.header.block")), 1),
            createVNode(_sfc_main$g, {
              "label-hover": unref(t)("wallet.transactions.button.copy.block.hover"),
              "notification-text": unref(t)("wallet.transactions.button.copy.block.notify"),
              "copy-text": __props.blockNo.toString(),
              class: "ml-1 inline-flex items-center justify-center"
            }, null, 8, ["label-hover", "notification-text", "copy-text"])
          ]),
          createVNode(_sfc_main$i, {
            subject: { blockNo: __props.blockNo, blockHash: __props.blochHash },
            type: "block",
            label: __props.blockNo.toString(),
            "label-c-s-s": "cc-addr hover:text-gray-500 mt-px"
          }, null, 8, ["subject", "label"])
        ])) : (openBlock(), createElementBlock("div", _hoisted_9$6, [
          createBaseVNode("div", _hoisted_10$6, [
            createBaseVNode("span", _hoisted_11$6, toDisplayString(unref(t)("wallet.transactions.header.size")), 1)
          ]),
          createBaseVNode("span", _hoisted_12$5, toDisplayString(__props.tx.size ?? 0), 1)
        ])),
        deposit.value !== "0" ? (openBlock(), createElementBlock("div", _hoisted_13$4, [
          createBaseVNode("div", _hoisted_14$3, toDisplayString(unref(t)("wallet.transactions.header.deposit")), 1),
          createVNode(_sfc_main$k, {
            amount: deposit.value,
            "balance-always-visible": "",
            colored: "",
            "text-c-s-s": "justify-end flex-nowrap -mt-px"
          }, null, 8, ["amount"])
        ])) : createCommentVNode("", true),
        donation.value !== "0" ? (openBlock(), createElementBlock("div", _hoisted_15$3, [
          createBaseVNode("div", _hoisted_16$3, toDisplayString(unref(t)("wallet.transactions.header.donation")), 1),
          createVNode(_sfc_main$k, {
            amount: donation.value,
            colored: "",
            "text-c-s-s": "justify-end flex-nowrap -mt-px"
          }, null, 8, ["amount"])
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_17$3, [
          createBaseVNode("div", _hoisted_18$3, toDisplayString(unref(t)("wallet.transactions.header.fee")), 1),
          createVNode(_sfc_main$k, {
            amount: "-" + __props.tx.body.fee,
            "balance-always-visible": "",
            colored: "",
            "text-c-s-s": "justify-end flex-nowrap -mt-px"
          }, null, 8, ["amount"])
        ])
      ]);
    };
  }
});
const _hoisted_1$b = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$b = { class: "flex flex-col flex-nowrap items-start cc-text-sm" };
const _hoisted_3$a = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_4$a = { class: "flex flex-row flex-nowrap pt-0 space-x-1" };
const _hoisted_5$9 = { key: 0 };
const _sfc_main$b = /* @__PURE__ */ defineComponent({
  __name: "GridTxListWithdrawalInfo",
  props: {
    accountId: { type: String, required: false, default: "" },
    tx: { type: Object, required: true },
    hash: { type: String, required: false, default: "" },
    txViewer: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const { isSignedHash } = useWitnesses();
    const withdrawals = computed(() => {
      var _a;
      const withdrawalList = [];
      if (!((_a = props.tx) == null ? void 0 : _a.body.withdrawals)) {
        return withdrawalList;
      }
      let i = 0;
      for (const withdrawal of Object.entries(props.tx.body.withdrawals)) {
        let hash = null;
        try {
          hash = getAddressCredentials(withdrawal[0]).stakeCred;
        } catch (err) {
          console.warn(err == null ? void 0 : err.message);
        }
        withdrawalList.push({
          bech32: withdrawal[0],
          hash: hash ?? "",
          amount: withdrawal[1],
          utxo: {
            input: { transaction_id: props.hash, index: i++ },
            output: { address: withdrawal[0], amount: { coin: withdrawal[1] } },
            pc: "",
            sc: hash ?? ""
          }
        });
      }
      return withdrawalList;
    });
    return (_ctx, _cache) => {
      return withdrawals.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1$b, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full my-2"
        }),
        createBaseVNode("div", _hoisted_2$b, [
          createBaseVNode("div", _hoisted_3$a, toDisplayString(withdrawals.value.length + " " + unref(t)("wallet.transactions.header.withdrawal.label")), 1),
          (openBlock(true), createElementBlock(Fragment, null, renderList(withdrawals.value, (withdrawal, index) => {
            return openBlock(), createElementBlock("div", {
              class: "w-full flex flex-row flex-nowrap items-start justify-between",
              key: index
            }, [
              createBaseVNode("div", _hoisted_4$a, [
                unref(isSignedHash)(withdrawal.hash) ? (openBlock(), createElementBlock("div", _hoisted_5$9, [
                  _cache[1] || (_cache[1] = createBaseVNode("i", { class: "mdi mdi-lock-open-check mr-1 cc-text-green" }, null, -1)),
                  createVNode(_sfc_main$h, {
                    anchor: "bottom middle",
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => _cache[0] || (_cache[0] = [
                      createTextVNode(toDisplayString("Witness included"))
                    ])),
                    _: 1
                  })
                ])) : createCommentVNode("", true),
                createVNode(_sfc_main$g, {
                  "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                  "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                  "copy-text": withdrawal.bech32,
                  class: ""
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createVNode(_sfc_main$i, {
                  subject: withdrawal,
                  type: "address",
                  label: withdrawal.bech32,
                  "label-c-s-s": "cc-addr  ",
                  class: ""
                }, null, 8, ["subject", "label"]),
                createVNode(_sfc_main$j, {
                  utxo: withdrawal.utxo,
                  "tx-viewer": __props.txViewer,
                  "account-id": __props.accountId,
                  "tx-hash": __props.hash,
                  "cred-type": "stake"
                }, null, 8, ["utxo", "tx-viewer", "account-id", "tx-hash"])
              ]),
              createVNode(_sfc_main$k, {
                amount: withdrawal.amount,
                "text-c-s-s": "flex-nowrap justify-end ml-2"
              }, null, 8, ["amount"])
            ]);
          }), 128))
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$a = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$a = { class: "flex flex-col flex-nowrap items-start cc-text-sm" };
const _hoisted_3$9 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_4$9 = { class: "flex flex-row flex-nowrap gap-2 items-start" };
const _hoisted_5$8 = { key: 0 };
const _hoisted_6$6 = {
  key: 1,
  class: "h-min"
};
const _hoisted_7$6 = { class: "cc-badge-green cc-none inline-flex my-1" };
const _hoisted_8$6 = {
  key: 2,
  class: "cc-badge-yellow cc-none inline-flex my-1"
};
const _sfc_main$a = /* @__PURE__ */ defineComponent({
  __name: "GridTxListMint",
  props: {
    tx: { type: Object, required: true },
    witnessCheck: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const { hasMintRedeemer } = useWitnesses();
    const open = ref(false);
    const mintCount = computed(() => {
      var _a;
      if (!((_a = props.tx) == null ? void 0 : _a.body.mint)) {
        return 0;
      }
      let count = 0;
      for (const policy of props.tx.body.mint) {
        for (let k in policy[1]) {
          ++count;
        }
      }
      return count;
    });
    function createAssetDetails(policy, name, quantity) {
      return {
        p: policy,
        t: { a: name, q: quantity },
        n: formatAssetName(name),
        f: getAssetIdBech32(policy, name)
      };
    }
    return (_ctx, _cache) => {
      return __props.tx.body.mint ? (openBlock(), createElementBlock("div", _hoisted_1$a, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full my-2"
        }),
        createBaseVNode("div", _hoisted_2$a, [
          createBaseVNode("div", {
            class: "flex flex-row flex-nowrap items-center cursor-pointer",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => open.value = !open.value, ["prevent", "stop"]))
          }, [
            createBaseVNode("div", _hoisted_3$9, toDisplayString(mintCount.value + " " + unref(t)("wallet.transactions.header.mint.label")), 1),
            createBaseVNode("i", {
              class: normalizeClass(["text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2)
          ]),
          open.value ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(__props.tx.body.mint, (policy, p_index) => {
            return openBlock(), createElementBlock("div", { key: p_index }, [
              (openBlock(true), createElementBlock(Fragment, null, renderList(Object.entries(policy[1]), (asset, a_index) => {
                return openBlock(), createElementBlock("div", {
                  class: "cc-bg-txdetails cc-rounded my-1 p-1 px-2",
                  key: a_index
                }, [
                  createBaseVNode("div", _hoisted_4$9, [
                    __props.witnessCheck && unref(hasMintRedeemer)(policy[0]) ? (openBlock(), createElementBlock("div", _hoisted_5$8, [
                      _cache[2] || (_cache[2] = createBaseVNode("i", { class: "mdi mdi-lock-open-check mr-1 cc-text-green" }, null, -1)),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => _cache[1] || (_cache[1] = [
                          createTextVNode(toDisplayString("Witness included"))
                        ])),
                        _: 1
                      })
                    ])) : createCommentVNode("", true),
                    compare(asset[1], ">", 0) ? (openBlock(), createElementBlock("div", _hoisted_6$6, [
                      createBaseVNode("div", _hoisted_7$6, toDisplayString(unref(t)("common.label.mint")), 1)
                    ])) : (openBlock(), createElementBlock("div", _hoisted_8$6, toDisplayString(unref(t)("common.label.burn")), 1)),
                    createVNode(_sfc_main$m, {
                      asset: createAssetDetails(policy[0], asset[0], asset[1]),
                      class: "mt-1"
                    }, null, 8, ["asset"])
                  ])
                ]);
              }), 128))
            ]);
          }), 128)) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$9 = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$9 = { class: "flex flex-col flex-nowrap items-start cc-text-sm" };
const _hoisted_3$8 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_4$8 = { class: "table-auto" };
const _hoisted_5$7 = {
  key: 0,
  class: "align-middle cc-text-xs"
};
const _hoisted_6$5 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_7$5 = { class: "w-5 align-text-top" };
const _hoisted_8$5 = { class: "flex flex-row flex-nowrap" };
const _hoisted_9$5 = {
  key: 1,
  class: "align-middle cc-text-xs"
};
const _hoisted_10$5 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap capitalize" };
const _hoisted_11$5 = { class: "w-5 align-text-top" };
const _hoisted_12$4 = { class: "flex flex-row flex-nowrap" };
const _hoisted_13$3 = {
  key: 2,
  class: "align-middle cc-text-xs"
};
const _hoisted_14$2 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_15$2 = { class: "w-5 align-text-top" };
const _hoisted_16$2 = { class: "flex flex-row flex-nowrap" };
const _hoisted_17$2 = { class: "cc-addr hover:text-gray-500" };
const _hoisted_18$2 = {
  key: 3,
  class: "align-middle cc-text-xs"
};
const _hoisted_19$2 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_20$2 = { class: "w-5 align-text-top" };
const _hoisted_21$2 = { class: "flex flex-row flex-nowrap" };
const _hoisted_22$2 = { class: "cc-addr hover:text-gray-500" };
const _hoisted_23$2 = {
  key: 4,
  class: "align-middle cc-text-xs"
};
const _hoisted_24$2 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_25$2 = {
  key: 5,
  class: "align-middle cc-text-xs"
};
const _hoisted_26$2 = { class: "pr-1 cc-text-semi-bold align-text-top whitespace-nowrap capitalize" };
const _hoisted_27$2 = { class: "w-5 align-text-top" };
const _hoisted_28$2 = { class: "w-full font-mono overflow-auto" };
const _hoisted_29$2 = {
  key: 6,
  class: "align-middle cc-text-xs"
};
const _hoisted_30$2 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_31$2 = {
  key: 7,
  class: "align-middle cc-text-xs"
};
const _hoisted_32$2 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_33$2 = {
  key: 8,
  class: "align-middle cc-text-xs"
};
const _hoisted_34$2 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_35$2 = { class: "cc-text-xs" };
const _hoisted_36$2 = {
  key: 9,
  class: "align-middle cc-text-xs"
};
const _hoisted_37$2 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_38$2 = {
  key: 10,
  class: "align-middle cc-text-xs"
};
const _hoisted_39$2 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_40$2 = { class: "w-5 align-text-top" };
const _hoisted_41$2 = { class: "flex flex-row flex-nowrap" };
const _hoisted_42$2 = { class: "pr-1 cc-text-semi-bold align-text-top whitespace-nowrap" };
const _hoisted_43$2 = { key: 0 };
const _hoisted_44$2 = { class: "w-5 align-text-top" };
const _hoisted_45$2 = { class: "flex flex-col flex-nowrap" };
const _hoisted_46$2 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold align-text-top whitespace-nowrap"
};
const _hoisted_47$2 = { key: 0 };
const _hoisted_48$2 = { class: "flex flex-col flex-nowrap space-y-1" };
const _hoisted_49$2 = { class: "flex flex-row flex-nowrap cc-addr" };
const _hoisted_50$2 = { key: 0 };
const _hoisted_51$2 = {
  key: 13,
  class: "align-middle cc-text-xs"
};
const _hoisted_52$2 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_53$2 = ["href"];
const _hoisted_54$2 = { class: "cc-addr hover:text-gray-500 self-center" };
const _hoisted_55$2 = {
  key: 14,
  class: "align-middle cc-text-xs"
};
const _hoisted_56$2 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold"
};
const _hoisted_57$2 = { class: "cc-addr" };
const _hoisted_58$2 = {
  key: 15,
  class: "align-middle cc-text-xs"
};
const _hoisted_59$2 = { class: "pr-1 cc-text-semi-bold align-text-top whitespace-nowrap" };
const _hoisted_60$1 = { class: "w-5 align-text-top" };
const _hoisted_61$1 = { class: "w-full font-mono overflow-auto" };
const _sfc_main$9 = /* @__PURE__ */ defineComponent({
  __name: "GridTxListCertificateInfo",
  props: {
    tx: { type: Object, required: true }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const open = ref(false);
    const certList = computed(() => {
      var _a;
      const certs = [];
      if (!((_a = props.tx) == null ? void 0 : _a.body.certs)) {
        return certs;
      }
      for (const cert of props.tx.body.certs) {
        const id = CertificateTypes.findIndex((type) => type === Object.keys(cert)[0]);
        switch (id) {
          case CertificateKind.StakeRegistration:
            try {
              const regCert = cert.StakeRegistration;
              const cred = Object.values(regCert.stake_credential)[0];
              const coin = regCert.coin ?? void 0;
              const bech32 = getRewardAddressFromCred(cred, networkId.value);
              certs.push({ kind: id, cert, coin, stakeAddr: { hash: cred, bech32 }, label: t("wallet.transactions.header.certificate.type.stakereg") });
            } catch (err) {
              console.warn(err == null ? void 0 : err.message);
            }
            break;
          case CertificateKind.StakeDeregistration:
            try {
              const deregCert = cert.StakeDeregistration;
              const cred = Object.values(deregCert.stake_credential)[0];
              const coin = deregCert.coin ?? void 0;
              const bech32 = getRewardAddressFromCred(cred, networkId.value);
              certs.push({ kind: id, cert, coin, stakeAddr: { hash: cred, bech32 }, label: t("wallet.transactions.header.certificate.type.stakedereg") });
            } catch (err) {
              console.warn(err == null ? void 0 : err.message);
            }
            break;
          case CertificateKind.StakeDelegation:
          case CertificateKind.StakeRegistrationAndDelegation:
            try {
              const delegation = cert.hasOwnProperty("StakeDelegation") ? cert.StakeDelegation : cert.StakeRegistrationAndDelegation;
              const coin = delegation.hasOwnProperty("coin") ? delegation.coin : void 0;
              const cred = Object.values(delegation.stake_credential)[0];
              const stakeBech32 = getRewardAddressFromCred(cred, networkId.value);
              const poolBech32 = getPoolAddressFromKeyHash(delegation.pool_keyhash);
              const certType = cert.hasOwnProperty("StakeDelegation") ? "stakedel" : "stakeregdel";
              certs.push({ kind: id, cert, coin, stakeAddr: { hash: cred, bech32: stakeBech32 }, poolAddr: { hash: delegation.pool_keyhash, bech32: poolBech32 }, label: t(`wallet.transactions.header.certificate.type.${certType}`) });
            } catch (err) {
              console.warn(err == null ? void 0 : err.message);
            }
            break;
          case CertificateKind.StakeAndVoteDelegation:
          case CertificateKind.StakeVoteRegistrationAndDelegation:
            try {
              const delegation = cert.hasOwnProperty("StakeAndVoteDelegation") ? cert.StakeAndVoteDelegation : cert.StakeVoteRegistrationAndDelegation;
              const coin = delegation.hasOwnProperty("coin") ? delegation.coin : void 0;
              const cred = Object.values(delegation.stake_credential)[0];
              const stakeBech32 = getRewardAddressFromCred(cred, networkId.value);
              const poolBech32 = getPoolAddressFromKeyHash(delegation.pool_keyhash);
              const certType = cert.hasOwnProperty("StakeAndVoteDelegation") ? "stakevotedel" : "stakevoteregdel";
              certs.push({ kind: id, cert, coin, stakeAddr: { hash: cred, bech32: stakeBech32 }, drep: delegation.drep, poolAddr: { hash: delegation.pool_keyhash, bech32: poolBech32 }, label: t(`wallet.transactions.header.certificate.type.${certType}`) });
            } catch (err) {
              console.warn(err == null ? void 0 : err.message);
            }
            break;
          case CertificateKind.VoteDelegation:
          case CertificateKind.VoteRegistrationAndDelegation:
            try {
              const delegation = cert.hasOwnProperty("VoteDelegation") ? cert.VoteDelegation : cert.VoteRegistrationAndDelegation;
              const cred = Object.values(delegation.stake_credential)[0];
              const coin = delegation.hasOwnProperty("coin") ? delegation.coin : void 0;
              const stakeBech32 = getRewardAddressFromCred(cred, networkId.value);
              const certType = cert.hasOwnProperty("VoteDelegation") ? "votedel" : "voteregdel";
              certs.push({ kind: id, cert, coin, stakeAddr: { hash: cred, bech32: stakeBech32 }, drep: delegation.drep, label: t(`wallet.transactions.header.certificate.type.${certType}`) });
            } catch (err) {
              console.warn(err == null ? void 0 : err.message);
            }
            break;
          case CertificateKind.DRepRegistration:
          case CertificateKind.DRepUpdate:
          case CertificateKind.DRepDeregistration:
            try {
              let cred = "";
              let isScript = false;
              let certType = "";
              let coin;
              let anchor;
              if (cert.hasOwnProperty("DRepRegistration")) {
                certType = "drepreg";
                const _cert = cert.DRepRegistration;
                cred = Object.values(_cert.voting_credential)[0];
                isScript = _cert.voting_credential.hasOwnProperty("Script");
                coin = _cert.coin;
                anchor = _cert.anchor;
              } else if (cert.hasOwnProperty("DRepUpdate")) {
                certType = "drepupd";
                const _cert = cert.DRepUpdate;
                cred = Object.values(_cert.voting_credential)[0];
                isScript = _cert.voting_credential.hasOwnProperty("Script");
                anchor = _cert.anchor;
              } else {
                certType = "drepdereg";
                const _cert = cert.DRepDeregistration;
                cred = Object.values(_cert.voting_credential)[0];
                isScript = _cert.voting_credential.hasOwnProperty("Script");
                coin = _cert.coin;
              }
              const drepBech32 = getDRepAddressFromKeyHash(cred, isScript);
              certs.push({ kind: id, cert, coin, drep: drepBech32, anchor, label: t(`wallet.transactions.header.certificate.type.${certType}`) });
            } catch (err) {
              console.warn(err == null ? void 0 : err.message);
            }
            break;
          case CertificateKind.PoolRegistration:
            try {
              const poolReg = cert.PoolRegistration;
              const params = poolReg.pool_params;
              const stakeCred = getAddressCredentials(poolReg.pool_params.reward_account).stakeCred ?? "";
              const poolBech32 = getPoolAddressFromKeyHash(params.operator);
              const poolOwners = [];
              const poolRelays = [];
              for (const owner of params.pool_owners) {
                poolOwners.push({ hash: owner, bech32: getRewardAddressFromCred(owner, networkId.value) });
              }
              for (const relayJSON of params.relays) {
                const relay = { address: "" };
                if ("SingleHostAddr" in relayJSON) {
                  const shaJSON = relayJSON.SingleHostAddr;
                  if (shaJSON.ipv4) {
                    relay.address = shaJSON.ipv4.join(".");
                  } else if (shaJSON.ipv6) {
                    relay.address = shaJSON.ipv6.join(".");
                  }
                  if (shaJSON.port) {
                    relay.port = shaJSON.port;
                  }
                } else if ("SingleHostName" in relayJSON) {
                  const shnJSON = relayJSON.SingleHostName;
                  relay.address = shnJSON.dns_name;
                  if (shnJSON.port) {
                    relay.port = shnJSON.port;
                  }
                } else if ("MultiHostName" in relayJSON) {
                  const mhnJSON = relayJSON.MultiHostName;
                  relay.address = mhnJSON.dns_name;
                }
                poolRelays.push(relay);
              }
              certs.push({ kind: id, cert, stakeAddr: { hash: stakeCred, bech32: poolReg.pool_params.reward_account }, poolAddr: { hash: params.operator, bech32: poolBech32 }, poolParams: poolReg.pool_params, poolOwners, poolRelays, label: t("wallet.transactions.header.certificate.type.poolreg") });
            } catch (err) {
              console.warn(err == null ? void 0 : err.message);
            }
            break;
          case CertificateKind.PoolRetirement:
            try {
              const poolRet = cert.PoolRetirement;
              const poolBech32 = getPoolAddressFromKeyHash(poolRet.pool_keyhash);
              certs.push({ kind: id, cert, poolAddr: { hash: poolRet.pool_keyhash, bech32: poolBech32 }, label: t("wallet.transactions.header.certificate.type.poolret") });
            } catch (err) {
              console.warn(err == null ? void 0 : err.message);
            }
            break;
          default:
            certs.push({ kind: id, unknown: true, cert, label: t("common.txtype.unknown") });
        }
      }
      return certs;
    });
    const getDRep = (drep) => {
      if (typeof drep === "string") {
        if (drep === "AlwaysAbstain") {
          return "Abstain";
        } else if (drep === "AlwaysNoConfidence") {
          return "No Confidence";
        }
        return drep;
      }
      let drepStr = Object.values(drep)[0];
      try {
        drepStr = getDRepAddressFromKeyHash(drepStr, drep.hasOwnProperty("ScriptHash"));
      } catch (e) {
      }
      return drepStr;
    };
    const getDRepCIP105 = (drep) => {
      if (typeof drep === "string") {
        if (drep === "AlwaysAbstain") {
          return "Abstain";
        } else if (drep === "AlwaysNoConfidence") {
          return "No Confidence";
        }
        return drep;
      }
      let drepStr = Object.values(drep)[0];
      try {
        drepStr = getDRepAddressFromKeyHashOld(drepStr, drep.hasOwnProperty("ScriptHash"));
      } catch (e) {
      }
      return drepStr;
    };
    return (_ctx, _cache) => {
      return certList.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1$9, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full my-2"
        }),
        createBaseVNode("div", _hoisted_2$9, [
          createBaseVNode("div", {
            class: "flex flex-row flex-nowrap items-center cursor-pointer",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => open.value = !open.value, ["prevent", "stop"]))
          }, [
            createBaseVNode("div", _hoisted_3$8, toDisplayString(certList.value.length + " " + unref(t)("wallet.transactions.header.certificate.label")), 1),
            createBaseVNode("i", {
              class: normalizeClass(["text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2)
          ]),
          open.value ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(certList.value, (cert, index) => {
            var _a, _b;
            return openBlock(), createElementBlock("div", {
              class: "cc-bg-txdetails w-full flex flex-col flex-nowrap items-start cc-rounded my-1 p-1 px-2",
              key: index
            }, [
              createVNode(GridSpace, {
                "color-label": "",
                hr: "",
                class: "w-full my-1",
                label: cert.label,
                "align-label": "left"
              }, null, 8, ["label"]),
              createBaseVNode("table", _hoisted_4$8, [
                createBaseVNode("tbody", null, [
                  cert.stakeAddr ? (openBlock(), createElementBlock("tr", _hoisted_5$7, [
                    createBaseVNode("td", _hoisted_6$5, toDisplayString(unref(t)("common.address.label")), 1),
                    createBaseVNode("td", _hoisted_7$5, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                        "copy-text": cert.stakeAddr.bech32,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_8$5, [
                      createVNode(_sfc_main$i, {
                        subject: cert.stakeAddr,
                        type: "stake",
                        label: cert.stakeAddr.bech32,
                        "label-c-s-s": "cc-addr hover:text-gray-500"
                      }, null, 8, ["subject", "label"])
                    ])
                  ])) : createCommentVNode("", true),
                  cert.poolAddr ? (openBlock(), createElementBlock("tr", _hoisted_9$5, [
                    createBaseVNode("td", _hoisted_10$5, toDisplayString(unref(t)("common.label.pool")), 1),
                    createBaseVNode("td", _hoisted_11$5, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.staking.poollist.poolid.hover"),
                        "notification-text": unref(t)("wallet.staking.poollist.poolid.notify"),
                        "copy-text": cert.poolAddr.bech32,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_12$4, [
                      createVNode(_sfc_main$i, {
                        subject: cert.poolAddr,
                        type: "pool",
                        label: cert.poolAddr.bech32,
                        "label-c-s-s": "cc-addr hover:text-gray-500"
                      }, null, 8, ["subject", "label"])
                    ])
                  ])) : createCommentVNode("", true),
                  cert.drep ? (openBlock(), createElementBlock("tr", _hoisted_13$3, [
                    createBaseVNode("td", _hoisted_14$2, toDisplayString(unref(t)(`wallet.transactions.header.certificate.gov.${typeof cert.drep === "string" && cert.drep.length < 56 ? "vote" : "drep105"}`)), 1),
                    createBaseVNode("td", _hoisted_15$2, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                        "copy-text": getDRepCIP105(cert.drep),
                        class: "ml-1 inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_16$2, [
                      createBaseVNode("div", _hoisted_17$2, toDisplayString(getDRepCIP105(cert.drep)), 1)
                    ])
                  ])) : createCommentVNode("", true),
                  cert.drep ? (openBlock(), createElementBlock("tr", _hoisted_18$2, [
                    createBaseVNode("td", _hoisted_19$2, toDisplayString(unref(t)(`wallet.transactions.header.certificate.gov.${typeof cert.drep === "string" && cert.drep.length < 56 ? "vote" : "drep"}`)), 1),
                    createBaseVNode("td", _hoisted_20$2, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                        "copy-text": getDRep(cert.drep),
                        class: "ml-1 inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_21$2, [
                      createBaseVNode("div", _hoisted_22$2, toDisplayString(getDRep(cert.drep)), 1)
                    ])
                  ])) : createCommentVNode("", true),
                  cert.coin ? (openBlock(), createElementBlock("tr", _hoisted_23$2, [
                    createBaseVNode("td", _hoisted_24$2, toDisplayString(unref(t)("common.label.deposit")), 1),
                    createBaseVNode("td", null, [
                      createVNode(_sfc_main$k, {
                        amount: cert.coin,
                        "show-fraction": false,
                        "balance-always-visible": "",
                        "text-c-s-s": "cc-text-xs"
                      }, null, 8, ["amount"])
                    ])
                  ])) : createCommentVNode("", true),
                  cert.anchor ? (openBlock(), createElementBlock("tr", _hoisted_25$2, [
                    createBaseVNode("td", _hoisted_26$2, [
                      createTextVNode(toDisplayString(unref(t)("common.label.anchor")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.hover")), 1)
                        ]),
                        _: 1
                      })
                    ]),
                    createBaseVNode("td", _hoisted_27$2, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.json.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.json.notify"),
                        "copy-text": JSON.stringify(cert.anchor),
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_28$2, [
                      createVNode(unref(S), {
                        showLength: "",
                        showDoubleQuotes: false,
                        deep: 5,
                        data: cert.anchor
                      }, null, 8, ["data"])
                    ])
                  ])) : createCommentVNode("", true),
                  cert.kind === unref(CertificateKind).PoolRetirement ? (openBlock(), createElementBlock("tr", _hoisted_29$2, [
                    createBaseVNode("td", _hoisted_30$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolret.retepno")), 1),
                    createBaseVNode("td", null, toDisplayString(cert.cert.PoolRetirement.epoch), 1)
                  ])) : createCommentVNode("", true),
                  cert.poolParams ? (openBlock(), createElementBlock("tr", _hoisted_31$2, [
                    createBaseVNode("td", _hoisted_32$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolreg.fixedcost")), 1),
                    createBaseVNode("td", null, [
                      createVNode(_sfc_main$k, {
                        amount: cert.poolParams.cost,
                        "show-fraction": false,
                        "text-c-s-s": "cc-text-xs"
                      }, null, 8, ["amount"])
                    ])
                  ])) : createCommentVNode("", true),
                  cert.poolParams ? (openBlock(), createElementBlock("tr", _hoisted_33$2, [
                    createBaseVNode("td", _hoisted_34$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolreg.margin")), 1),
                    createBaseVNode("td", _hoisted_35$2, toDisplayString(parseFloat((parseInt(cert.poolParams.margin.numerator) / parseInt(cert.poolParams.margin.denominator) * 100).toFixed(4))) + " %", 1)
                  ])) : createCommentVNode("", true),
                  cert.poolParams ? (openBlock(), createElementBlock("tr", _hoisted_36$2, [
                    createBaseVNode("td", _hoisted_37$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolreg.pledge")), 1),
                    createBaseVNode("td", null, [
                      createVNode(_sfc_main$k, {
                        amount: cert.poolParams.pledge,
                        "show-fraction": false,
                        "text-c-s-s": "cc-text-xs"
                      }, null, 8, ["amount"])
                    ])
                  ])) : createCommentVNode("", true),
                  cert.poolParams && cert.stakeAddr ? (openBlock(), createElementBlock("tr", _hoisted_38$2, [
                    createBaseVNode("td", _hoisted_39$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolreg.rewardaddr")), 1),
                    createBaseVNode("td", _hoisted_40$2, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                        "copy-text": cert.stakeAddr.bech32,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_41$2, [
                      createVNode(_sfc_main$i, {
                        subject: cert.stakeAddr,
                        type: "stake",
                        label: cert.stakeAddr.bech32,
                        "label-c-s-s": "cc-addr hover:text-gray-500"
                      }, null, 8, ["subject", "label"])
                    ])
                  ])) : createCommentVNode("", true),
                  cert.poolParams && cert.poolOwners ? (openBlock(true), createElementBlock(Fragment, { key: 11 }, renderList(cert.poolOwners, (owner, index2) => {
                    return openBlock(), createElementBlock("tr", {
                      class: "align-middle cc-text-xs",
                      key: index2
                    }, [
                      createBaseVNode("td", _hoisted_42$2, [
                        index2 === 0 ? (openBlock(), createElementBlock("span", _hoisted_43$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolreg.owners")), 1)) : createCommentVNode("", true)
                      ]),
                      createBaseVNode("td", _hoisted_44$2, [
                        createVNode(_sfc_main$g, {
                          "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                          "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                          "copy-text": owner.bech32,
                          class: "ml-1 flex inline-flex items-center justify-center"
                        }, null, 8, ["label-hover", "notification-text", "copy-text"])
                      ]),
                      createBaseVNode("td", _hoisted_45$2, [
                        createVNode(_sfc_main$i, {
                          subject: owner,
                          type: "stake",
                          label: owner.bech32,
                          "label-c-s-s": "cc-addr hover:text-gray-500"
                        }, null, 8, ["subject", "label"])
                      ])
                    ]);
                  }), 128)) : createCommentVNode("", true),
                  cert.poolParams ? (openBlock(true), createElementBlock(Fragment, { key: 12 }, renderList(cert.poolRelays, (relay, index2) => {
                    return openBlock(), createElementBlock("tr", {
                      class: "align-middle cc-text-xs",
                      key: index2
                    }, [
                      createBaseVNode("td", _hoisted_46$2, [
                        index2 === 0 ? (openBlock(), createElementBlock("span", _hoisted_47$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolreg.relays")), 1)) : createCommentVNode("", true)
                      ]),
                      createBaseVNode("td", _hoisted_48$2, [
                        createBaseVNode("div", _hoisted_49$2, [
                          createBaseVNode("span", null, toDisplayString(relay.address), 1),
                          relay.port ? (openBlock(), createElementBlock("span", _hoisted_50$2, " : " + toDisplayString(relay.port), 1)) : createCommentVNode("", true)
                        ])
                      ])
                    ]);
                  }), 128)) : createCommentVNode("", true),
                  ((_a = cert.poolParams) == null ? void 0 : _a.pool_metadata) ? (openBlock(), createElementBlock("tr", _hoisted_51$2, [
                    createBaseVNode("td", _hoisted_52$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolreg.metaurl")), 1),
                    createBaseVNode("td", null, [
                      createBaseVNode("a", {
                        href: cert.poolParams.pool_metadata.url,
                        target: "_blank",
                        rel: "noopener noreferrer",
                        class: "flex flex-nowrap items-start"
                      }, [
                        createBaseVNode("div", _hoisted_54$2, toDisplayString(cert.poolParams.pool_metadata.url), 1),
                        _cache[1] || (_cache[1] = createBaseVNode("i", { class: "mdi mdi-open-in-new mx-1" }, null, -1))
                      ], 8, _hoisted_53$2)
                    ])
                  ])) : createCommentVNode("", true),
                  ((_b = cert.poolParams) == null ? void 0 : _b.pool_metadata) ? (openBlock(), createElementBlock("tr", _hoisted_55$2, [
                    createBaseVNode("td", _hoisted_56$2, toDisplayString(unref(t)("wallet.transactions.header.certificate.poolreg.metahash")), 1),
                    createBaseVNode("td", _hoisted_57$2, toDisplayString(cert.poolParams.pool_metadata.pool_metadata_hash), 1)
                  ])) : createCommentVNode("", true),
                  cert.unknown ? (openBlock(), createElementBlock("tr", _hoisted_58$2, [
                    createBaseVNode("td", _hoisted_59$2, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.hover")), 1)
                        ]),
                        _: 1
                      })
                    ]),
                    createBaseVNode("td", _hoisted_60$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.json.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.json.notify"),
                        "copy-text": JSON.stringify(cert.cert),
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_61$1, [
                      createVNode(unref(S), {
                        showLength: "",
                        showDoubleQuotes: false,
                        deep: 5,
                        data: cert.cert
                      }, null, 8, ["data"])
                    ])
                  ])) : createCommentVNode("", true)
                ])
              ])
            ]);
          }), 128)) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$8 = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$8 = { class: "cc-text-sm" };
const _hoisted_3$7 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_4$7 = { class: "flex flex-row flex-nowrap cc-text-xs" };
const _hoisted_5$6 = { class: "cc-text-semi-bold mr-4" };
const _hoisted_6$4 = { class: "w-full pb-1 pr-1 whitespace-pre-wrap overflow-auto" };
const _hoisted_7$4 = {
  key: 0,
  class: "w-full font-mono"
};
const _hoisted_8$4 = {
  key: 0,
  class: "cursor-pointer flex flex-nowrap items-start truncate"
};
const _hoisted_9$4 = ["href"];
const _hoisted_10$4 = { class: "self-center" };
const _hoisted_11$4 = { key: 1 };
const _sfc_main$8 = /* @__PURE__ */ defineComponent({
  __name: "GridTxListMetadata",
  props: {
    tx: { type: Object, required: true },
    decryptedMsg: { type: Array, required: false }
  },
  setup(__props) {
    var _a;
    const props = __props;
    const { t } = useTranslation();
    const open = ref(false);
    const metaCount = computed(() => {
      var _a2, _b;
      return Object.keys(((_b = (_a2 = props.tx) == null ? void 0 : _a2.auxiliary_data) == null ? void 0 : _b.metadata) ?? {}).length;
    });
    const isMilkomeda = isMilkomedaTx(((_a = props.tx) == null ? void 0 : _a.auxiliary_data) ?? null, networkId.value ? networkId.value : "mainnet");
    const milkomedaUrl = !isMilkomeda ? void 0 : getNetworkExplorerUrlFromItx(networkId.value ? networkId.value : "mainnet", props.tx.auxiliary_data);
    const getJsonMetadata = (metadata) => {
      var _a2;
      const json2 = {};
      createJsonFromCborJson(JSON.parse(metadata[1]), json2, void 0, false);
      if (metadata[0] === "674" && (((_a2 = props.decryptedMsg) == null ? void 0 : _a2.length) ?? 0) > 0) {
        json2.msg = props.decryptedMsg;
      }
      return json2;
    };
    return (_ctx, _cache) => {
      var _a2;
      return ((_a2 = __props.tx.auxiliary_data) == null ? void 0 : _a2.metadata) && metaCount.value > 0 ? (openBlock(), createElementBlock("div", _hoisted_1$8, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full my-2"
        }),
        createBaseVNode("div", _hoisted_2$8, [
          createBaseVNode("div", {
            class: "flex flex-row flex-nowrap items-center cursor-pointer",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => open.value = !open.value, ["prevent", "stop"]))
          }, [
            createBaseVNode("div", _hoisted_3$7, toDisplayString(metaCount.value + " " + unref(t)("wallet.transactions.header.metadata.label")), 1),
            createBaseVNode("i", {
              class: normalizeClass(["text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2)
          ]),
          open.value ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(Object.entries(__props.tx.auxiliary_data.metadata), (metadata, index) => {
            return openBlock(), createElementBlock("div", {
              class: "relative cc-rounded cc-bg-txdetails my-1 p-1 px-2",
              key: index
            }, [
              createBaseVNode("div", _hoisted_4$7, [
                createBaseVNode("div", _hoisted_5$6, [
                  createTextVNode(toDisplayString(unref(t)("wallet.transactions.header.metadata.key")) + " ", 1),
                  createVNode(_sfc_main$h, {
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.hover")), 1)
                    ]),
                    _: 1
                  })
                ]),
                createVNode(_sfc_main$g, {
                  label: metadata[0],
                  "label-hover": unref(t)("wallet.transactions.button.copy.metadata.hover"),
                  "notification-text": unref(t)("wallet.transactions.button.copy.metadata.notify"),
                  "copy-text": JSON.stringify(metadata, null, 2),
                  showCopiedContent: false,
                  class: "inline-flex items-center justify-center"
                }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
              ]),
              createBaseVNode("div", _hoisted_6$4, [
                unref(getMetadataType)(metadata[1]) === "string" || unref(getMetadataType)(metadata[1]) === "number" ? (openBlock(), createElementBlock("span", _hoisted_7$4, [
                  unref(isMilkomeda) && metadata[0] === String(unref(networkMetadataAddressKey)) ? (openBlock(), createElementBlock("div", _hoisted_8$4, [
                    createBaseVNode("a", {
                      href: unref(milkomedaUrl),
                      target: "_blank",
                      rel: "noopener noreferrer",
                      class: "flex flex-nowrap items-start truncate flex-row"
                    }, [
                      createBaseVNode("div", _hoisted_10$4, toDisplayString(unref(getJsonValue)(metadata[1])), 1),
                      _cache[1] || (_cache[1] = createBaseVNode("i", { class: "mdi mdi-open-in-new mx-1" }, null, -1)),
                      createVNode(_sfc_main$h, {
                        "tooltip-c-s-s": "whitespace-nowrap",
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.milkomeda.link.hover").replace("###NETWORK###", unref(networkId))), 1)
                        ]),
                        _: 1
                      })
                    ], 8, _hoisted_9$4)
                  ])) : (openBlock(), createElementBlock("span", _hoisted_11$4, toDisplayString(unref(getJsonValue)(metadata[1])), 1))
                ])) : (openBlock(), createBlock(unref(S), {
                  key: 1,
                  class: "w-full font-mono",
                  showLength: "",
                  showDoubleQuotes: false,
                  deep: 5,
                  data: getJsonMetadata(metadata)
                }, null, 8, ["data"]))
              ])
            ]);
          }), 128)) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$7 = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$7 = { class: "cc-text-sm" };
const _hoisted_3$6 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_4$6 = {
  key: 0,
  class: "relative cc-rounded cc-bg-txdetails my-1 p-1 px-2"
};
const _hoisted_5$5 = { class: "w-full pb-1 pr-1 whitespace-pre-wrap overflow-auto" };
const _sfc_main$7 = /* @__PURE__ */ defineComponent({
  __name: "GridTxListWitnessSet",
  props: {
    tx: { type: Object, required: true },
    decryptedMsg: { type: Array, required: false }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const open = ref(false);
    const hasWitness = computed(() => {
      var _a;
      return ((_a = props.tx) == null ? void 0 : _a.witness_set) !== void 0 && Object.keys(props.tx.witness_set).length > 0;
    });
    const getJsonMetadata = () => {
      var _a;
      const json2 = (_a = props.tx) == null ? void 0 : _a.witness_set;
      return json2;
    };
    return (_ctx, _cache) => {
      return hasWitness.value ? (openBlock(), createElementBlock("div", _hoisted_1$7, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full my-2"
        }),
        createBaseVNode("div", _hoisted_2$7, [
          createBaseVNode("div", {
            class: "flex flex-row flex-nowrap items-center cursor-pointer",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => open.value = !open.value, ["prevent", "stop"]))
          }, [
            createBaseVNode("div", _hoisted_3$6, toDisplayString(unref(t)("wallet.transactions.header.witnessset.label")), 1),
            createBaseVNode("i", {
              class: normalizeClass(["text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2)
          ]),
          open.value ? (openBlock(), createElementBlock("div", _hoisted_4$6, [
            _cache[1] || (_cache[1] = createBaseVNode("div", { class: "flex flex-row flex-nowrap cc-text-xs" }, null, -1)),
            createBaseVNode("div", _hoisted_5$5, [
              createVNode(unref(S), {
                class: "w-full font-mono",
                showLength: "",
                showDoubleQuotes: false,
                deep: 99,
                data: getJsonMetadata()
              }, null, 8, ["data"])
            ])
          ])) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$6 = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$6 = { class: "cc-text-sm" };
const _hoisted_3$5 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_4$5 = { class: "table-auto" };
const _hoisted_5$4 = { class: "cc-text-xs" };
const _hoisted_6$3 = { class: "align-middle cc-text-xs" };
const _hoisted_7$3 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_8$3 = { class: "w-5 align-text-top" };
const _hoisted_9$3 = { class: "cc-addr" };
const _hoisted_10$3 = { class: "align-middle cc-text-xs" };
const _hoisted_11$3 = { class: "pr-1 cc-text-semi-bold align-text-top whitespace-nowrap" };
const _hoisted_12$3 = { class: "w-5 align-text-top" };
const _hoisted_13$2 = { class: "w-full font-mono" };
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "GridTxListNativeScripts",
  props: {
    scriptList: { type: Array, required: true }
  },
  setup(__props) {
    const { t } = useTranslation();
    const open = ref(false);
    return (_ctx, _cache) => {
      return __props.scriptList.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1$6, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full my-2"
        }),
        createBaseVNode("div", _hoisted_2$6, [
          createBaseVNode("div", {
            class: "flex flex-row flex-nowrap items-center cursor-pointer",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => open.value = !open.value, ["prevent", "stop"]))
          }, [
            createBaseVNode("div", _hoisted_3$5, toDisplayString(__props.scriptList.length + " " + unref(t)("wallet.transactions.header.nativescript.label")), 1),
            createBaseVNode("i", {
              class: normalizeClass(["text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2)
          ]),
          open.value ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(__props.scriptList, (script, index) => {
            return openBlock(), createElementBlock("div", {
              class: "cc-bg-txdetails cc-rounded my-1 p-1 px-2",
              key: index
            }, [
              createBaseVNode("table", _hoisted_4$5, [
                createBaseVNode("tbody", _hoisted_5$4, [
                  createBaseVNode("tr", _hoisted_6$3, [
                    createBaseVNode("td", _hoisted_7$3, toDisplayString(unref(t)("wallet.transactions.header.nativescript.hash")), 1),
                    createBaseVNode("td", _hoisted_8$3, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.hash.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.hash.notify"),
                        "copy-text": script.scriptHash,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_9$3, toDisplayString(script.scriptHash), 1)
                  ]),
                  createBaseVNode("tr", _hoisted_10$3, [
                    createBaseVNode("td", _hoisted_11$3, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.header.nativescript.json")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.hover")), 1)
                        ]),
                        _: 1
                      })
                    ]),
                    createBaseVNode("td", _hoisted_12$3, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.script.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.script.notify"),
                        "copy-text": JSON.stringify(script.json),
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_13$2, [
                      createVNode(unref(S), {
                        showLength: "",
                        showDoubleQuotes: false,
                        deep: 5,
                        data: script.json
                      }, null, 8, ["data"])
                    ])
                  ])
                ])
              ])
            ]);
          }), 128)) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$5 = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$5 = { class: "flex flex-col flex-nowrap items-start cc-text-sm" };
const _hoisted_3$4 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_4$4 = { class: "w-full table-fixed" };
const _hoisted_5$3 = {
  key: 0,
  class: "align-middle cc-text-xs"
};
const _hoisted_6$2 = { class: "w-24 pr-1 cc-text-semi-bold text-left whitespace-nowrap capitalize" };
const _hoisted_7$2 = { class: "w-5 align-text-top" };
const _hoisted_8$2 = { class: "flex flex-row flex-nowrap mt-1" };
const _hoisted_9$2 = {
  key: 1,
  class: "h-0"
};
const _hoisted_10$2 = { class: "align-middle cc-text-xs" };
const _hoisted_11$2 = { colspan: "3" };
const _hoisted_12$2 = { class: "align-middle cc-text-xs" };
const _hoisted_13$1 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_14$1 = { class: "align-middle cc-text-xs" };
const _hoisted_15$1 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_16$1 = { class: "align-middle cc-text-xs" };
const _hoisted_17$1 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_18$1 = { class: "align-middle cc-text-xs" };
const _hoisted_19$1 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_20$1 = { class: "align-middle cc-text-xs" };
const _hoisted_21$1 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_22$1 = { class: "w-5 align-text-top" };
const _hoisted_23$1 = { class: "cc-addr truncate" };
const _hoisted_24$1 = {
  key: 2,
  class: "align-middle cc-text-xs"
};
const _hoisted_25$1 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_26$1 = { class: "w-5 align-text-top" };
const _hoisted_27$1 = { class: "cc-addr truncate" };
const _hoisted_28$1 = {
  key: 3,
  class: "align-middle cc-text-xs"
};
const _hoisted_29$1 = { class: "pr-1 cc-text-semi-bold align-text-top whitespace-nowrap" };
const _hoisted_30$1 = { class: "w-5 align-text-top" };
const _hoisted_31$1 = { class: "w-full font-mono" };
const _hoisted_32$1 = {
  key: 4,
  class: "align-middle cc-text-xs"
};
const _hoisted_33$1 = { colspan: "3" };
const _hoisted_34$1 = { class: "w-full flex flex-row flex-nowrap mt-1" };
const _hoisted_35$1 = {
  key: 5,
  class: "align-middle cc-text-xs"
};
const _hoisted_36$1 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_37$1 = { class: "w-5 align-text-top" };
const _hoisted_38$1 = { class: "cc-addr truncate" };
const _hoisted_39$1 = {
  key: 6,
  class: "align-middle cc-text-xs"
};
const _hoisted_40$1 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_41$1 = { class: "w-5 align-text-top" };
const _hoisted_42$1 = { class: "cc-addr truncate" };
const _hoisted_43$1 = {
  key: 7,
  class: "align-middle cc-text-xs"
};
const _hoisted_44$1 = { class: "pr-1 cc-text-semi-bold align-text-top whitespace-nowrap" };
const _hoisted_45$1 = { class: "w-5 align-text-top" };
const _hoisted_46$1 = { class: "w-full font-mono" };
const _hoisted_47$1 = {
  key: 8,
  class: "align-middle cc-text-xs"
};
const _hoisted_48$1 = { colspan: "3" };
const _hoisted_49$1 = { class: "w-full flex flex-row flex-nowrap mt-1" };
const _hoisted_50$1 = {
  key: 9,
  class: "align-middle cc-text-xs"
};
const _hoisted_51$1 = {
  colspan: "2",
  class: "pr-1 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_52$1 = {
  key: 10,
  class: "align-middle cc-text-xs"
};
const _hoisted_53$1 = { class: "pr-1 cc-text-semi-bold whitespace-nowrap" };
const _hoisted_54$1 = { class: "w-5 align-text-top" };
const _hoisted_55$1 = { class: "cc-addr truncate" };
const _hoisted_56$1 = {
  key: 11,
  class: "align-middle cc-text-xs"
};
const _hoisted_57$1 = { class: "pr-1 cc-text-semi-bold" };
const _hoisted_58$1 = { class: "w-5 align-text-top" };
const _hoisted_59$1 = { class: "truncate max-w-0" };
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "GridTxListPlutusSC",
  props: {
    tx: { type: Object, required: true },
    contractList: { type: Array, required: true, default: [] },
    isLoading: { type: Boolean, default: true }
  },
  setup(__props) {
    const { t } = useTranslation();
    const open = ref(false);
    return (_ctx, _cache) => {
      return __props.tx.witness_set.redeemers && __props.tx.witness_set.redeemers.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1$5, [
        createVNode(GridSpace, {
          hr: "",
          class: "w-full my-2"
        }),
        createBaseVNode("div", _hoisted_2$5, [
          createBaseVNode("div", {
            class: "flex flex-row flex-nowrap items-center cursor-pointer",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => open.value = !open.value, ["prevent", "stop"]))
          }, [
            createBaseVNode("div", _hoisted_3$4, toDisplayString(__props.tx.witness_set.redeemers.length + " " + unref(t)("wallet.transactions.header.plutuscontract.label")), 1),
            createBaseVNode("i", {
              class: normalizeClass(["text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2),
            __props.isLoading ? (openBlock(), createBlock(QSpinnerDots_default, {
              key: 0,
              color: "gray",
              size: "2em",
              class: "ml-2"
            })) : createCommentVNode("", true)
          ]),
          open.value ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(__props.contractList, (sc, index) => {
            return openBlock(), createElementBlock("div", {
              class: "w-full flex flex-col flex-nowrap items-start cc-bg-txdetails cc-rounded my-1 p-1 px-2",
              key: index
            }, [
              createBaseVNode("table", _hoisted_4$4, [
                createBaseVNode("tbody", null, [
                  sc.address || sc.scriptHash ? (openBlock(), createElementBlock("tr", _hoisted_5$3, [
                    createBaseVNode("td", _hoisted_6$2, toDisplayString(unref(t)("common.label.contract")), 1),
                    createBaseVNode("td", _hoisted_7$2, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
                        "copy-text": sc.address ?? sc.scriptHash,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_8$2, [
                      createVNode(_sfc_main$i, {
                        subject: sc.address ? { hash: unref(toHexString)(unref(getAddressCredentials)(sc.address, null, true).addressBytes), bech32: sc.address } : sc.scriptHash,
                        type: sc.address ? "address" : "policy",
                        label: sc.address ?? sc.scriptHash,
                        truncate: "",
                        "label-c-s-s": "cc-addr"
                      }, null, 8, ["subject", "type", "label"])
                    ])
                  ])) : (openBlock(), createElementBlock("tr", _hoisted_9$2, _cache[1] || (_cache[1] = [
                    createBaseVNode("td", { class: "w-24" }, null, -1),
                    createBaseVNode("td", { class: "w-5" }, null, -1),
                    createBaseVNode("td", null, null, -1)
                  ]))),
                  createBaseVNode("tr", _hoisted_10$2, [
                    createBaseVNode("td", _hoisted_11$2, [
                      createVNode(GridSpace, {
                        hr: "",
                        class: "w-full",
                        label: unref(t)("wallet.transactions.header.plutuscontract.redeemer"),
                        "align-label": "left"
                      }, null, 8, ["label"])
                    ])
                  ]),
                  createBaseVNode("tr", _hoisted_12$2, [
                    createBaseVNode("td", _hoisted_13$1, toDisplayString(unref(t)("wallet.transactions.header.plutus.redeemer.purpose")), 1),
                    createBaseVNode("td", null, toDisplayString(sc.input.redeemer.purpose), 1)
                  ]),
                  createBaseVNode("tr", _hoisted_14$1, [
                    createBaseVNode("td", _hoisted_15$1, toDisplayString(unref(t)("wallet.transactions.header.plutus.redeemer.fee")), 1),
                    createBaseVNode("td", null, toDisplayString(sc.input.redeemer.fee), 1)
                  ]),
                  createBaseVNode("tr", _hoisted_16$1, [
                    createBaseVNode("td", _hoisted_17$1, toDisplayString(unref(t)("wallet.transactions.header.plutus.redeemer.usteps")), 1),
                    createBaseVNode("td", null, toDisplayString(sc.input.redeemer.unit.steps), 1)
                  ]),
                  createBaseVNode("tr", _hoisted_18$1, [
                    createBaseVNode("td", _hoisted_19$1, toDisplayString(unref(t)("wallet.transactions.header.plutus.redeemer.umem")), 1),
                    createBaseVNode("td", null, toDisplayString(sc.input.redeemer.unit.mem), 1)
                  ]),
                  createBaseVNode("tr", _hoisted_20$1, [
                    createBaseVNode("td", _hoisted_21$1, toDisplayString(unref(t)("wallet.transactions.header.plutus.redeemer.dhash")), 1),
                    createBaseVNode("td", _hoisted_22$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.hash.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.hash.notify"),
                        "copy-text": sc.input.redeemer.datum.hash,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_23$1, toDisplayString(sc.input.redeemer.datum.hash), 1)
                  ]),
                  sc.input.redeemer.datum.bytes ? (openBlock(), createElementBlock("tr", _hoisted_24$1, [
                    createBaseVNode("td", _hoisted_25$1, toDisplayString(unref(t)("wallet.transactions.header.plutus.redeemer.dvalue")), 1),
                    createBaseVNode("td", _hoisted_26$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.datum.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.datum.notify"),
                        "copy-text": sc.input.redeemer.datum.bytes,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_27$1, toDisplayString(sc.input.redeemer.datum.bytes), 1)
                  ])) : createCommentVNode("", true),
                  sc.input.redeemer.datum.value.length > 0 ? (openBlock(), createElementBlock("tr", _hoisted_28$1, [
                    createBaseVNode("td", _hoisted_29$1, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.header.plutus.redeemer.djson")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.hover")), 1)
                        ]),
                        _: 1
                      })
                    ]),
                    createBaseVNode("td", _hoisted_30$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.datum.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.datum.notify"),
                        "copy-text": JSON.stringify(sc.input.redeemer.datum.value),
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_31$1, [
                      createVNode(unref(S), {
                        showLength: "",
                        showDoubleQuotes: false,
                        deep: 5,
                        data: sc.input.redeemer.datum.value
                      }, null, 8, ["data"])
                    ])
                  ])) : createCommentVNode("", true),
                  sc.input.datum ? (openBlock(), createElementBlock("tr", _hoisted_32$1, [
                    createBaseVNode("td", _hoisted_33$1, [
                      createBaseVNode("div", _hoisted_34$1, [
                        _cache[2] || (_cache[2] = createBaseVNode("i", { class: "mr-1 mdi mdi-plus" }, null, -1)),
                        createVNode(GridSpace, {
                          hr: "",
                          class: "w-full",
                          label: unref(t)("wallet.transactions.header.plutuscontract.datum"),
                          "align-label": "left"
                        }, null, 8, ["label"])
                      ])
                    ])
                  ])) : createCommentVNode("", true),
                  sc.input.datum ? (openBlock(), createElementBlock("tr", _hoisted_35$1, [
                    createBaseVNode("td", _hoisted_36$1, toDisplayString(unref(t)("wallet.transactions.header.plutus.datum.hash")), 1),
                    createBaseVNode("td", _hoisted_37$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.hash.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.hash.notify"),
                        "copy-text": sc.input.datum.hash,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_38$1, toDisplayString(sc.input.datum.hash), 1)
                  ])) : createCommentVNode("", true),
                  sc.input.datum && sc.input.datum.bytes ? (openBlock(), createElementBlock("tr", _hoisted_39$1, [
                    createBaseVNode("td", _hoisted_40$1, toDisplayString(unref(t)("wallet.transactions.header.plutus.datum.bytecode")), 1),
                    createBaseVNode("td", _hoisted_41$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.datum.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.datum.notify"),
                        "copy-text": sc.input.datum.bytes,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_42$1, toDisplayString(sc.input.datum.bytes), 1)
                  ])) : createCommentVNode("", true),
                  sc.input.datum && sc.input.datum.value.length > 0 ? (openBlock(), createElementBlock("tr", _hoisted_43$1, [
                    createBaseVNode("td", _hoisted_44$1, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.header.plutus.datum.json")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.hover")), 1)
                        ]),
                        _: 1
                      })
                    ]),
                    createBaseVNode("td", _hoisted_45$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.datum.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.datum.notify"),
                        "copy-text": JSON.stringify(sc.input.datum.value),
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_46$1, [
                      createVNode(unref(S), {
                        showLength: "",
                        showDoubleQuotes: false,
                        deep: 5,
                        data: sc.input.datum.value
                      }, null, 8, ["data"])
                    ])
                  ])) : createCommentVNode("", true),
                  sc.size || sc.scriptHash || sc.bytecode ? (openBlock(), createElementBlock("tr", _hoisted_47$1, [
                    createBaseVNode("td", _hoisted_48$1, [
                      createBaseVNode("div", _hoisted_49$1, [
                        _cache[3] || (_cache[3] = createBaseVNode("i", { class: "mr-1 mdi mdi-arrow-down" }, null, -1)),
                        createVNode(GridSpace, {
                          hr: "",
                          class: "w-full",
                          label: unref(t)("wallet.transactions.header.plutuscontract.script.label"),
                          "align-label": "left"
                        }, null, 8, ["label"])
                      ])
                    ])
                  ])) : createCommentVNode("", true),
                  sc.size || sc.scriptHash || sc.bytecode ? (openBlock(), createElementBlock("tr", _hoisted_50$1, [
                    createBaseVNode("td", _hoisted_51$1, toDisplayString(unref(t)("wallet.transactions.header.plutuscontract.script.size")), 1),
                    createBaseVNode("td", null, toDisplayString(sc.size), 1)
                  ])) : createCommentVNode("", true),
                  sc.size || sc.scriptHash || sc.bytecode ? (openBlock(), createElementBlock("tr", _hoisted_52$1, [
                    createBaseVNode("td", _hoisted_53$1, toDisplayString(unref(t)("wallet.transactions.header.plutuscontract.script.hash")), 1),
                    createBaseVNode("td", _hoisted_54$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.hash.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.hash.notify"),
                        "copy-text": sc.scriptHash,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_55$1, toDisplayString(sc.scriptHash), 1)
                  ])) : createCommentVNode("", true),
                  sc.size || sc.scriptHash || sc.bytecode ? (openBlock(), createElementBlock("tr", _hoisted_56$1, [
                    createBaseVNode("td", _hoisted_57$1, toDisplayString(unref(t)("wallet.transactions.header.plutuscontract.script.bytecode")), 1),
                    createBaseVNode("td", _hoisted_58$1, [
                      createVNode(_sfc_main$g, {
                        "label-hover": unref(t)("wallet.transactions.button.copy.script.hover"),
                        "notification-text": unref(t)("wallet.transactions.button.copy.script.notify"),
                        "copy-text": sc.bytecode,
                        class: "ml-1 flex inline-flex items-center justify-center"
                      }, null, 8, ["label-hover", "notification-text", "copy-text"])
                    ]),
                    createBaseVNode("td", _hoisted_59$1, toDisplayString(sc.bytecode), 1)
                  ])) : createCommentVNode("", true)
                ])
              ])
            ]);
          }), 128)) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$4 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$4 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$3 = { class: "grid grid-cols-12 cc-gap p-4 w-full" };
const _hoisted_4$3 = { class: "grid grid-cols-12 cc-gap p-2 w-full border-t" };
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "NoteModal",
  props: {
    note: { type: null, required: true, default: null },
    textId: { type: String, required: false, default: void 0 },
    title: { type: String, required: false, default: void 0 },
    caption: { type: String, required: false, default: void 0 },
    modalCSS: { type: String, required: false, default: void 0 },
    scrollable: { type: Boolean, required: false, default: false },
    persistent: { type: Boolean, required: false, default: false },
    repeatPassword: { type: Boolean, required: false, default: false },
    validatePassword: { type: Boolean, required: false, default: false },
    confirmLabel: { type: String, required: false, default: void 0 }
  },
  emits: ["close", "confirm", "delete"],
  setup(__props, { emit: __emit }) {
    var _a;
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const showModal = ref(true);
    const showDeleteModal = ref({ display: false });
    const confirmLabel = ref(props.confirmLabel);
    const deletable = computed(() => {
      var _a2;
      return (((_a2 = props.note) == null ? void 0 : _a2.note.length) ?? 0) > 0;
    });
    if (props.confirmLabel === void 0) {
      confirmLabel.value = it("wallet.transactions.note.save");
    }
    const textInput = ref(((_a = props.note) == null ? void 0 : _a.note) ?? "");
    const onConfirm = () => {
      showModal.value = false;
      emit("confirm", { text: textInput.value });
      showModal.value = false;
    };
    const onDelete = () => {
      emit("delete");
      showDeleteModal.value.display = false;
    };
    const onClose = () => {
      showModal.value = false;
      emit("close");
    };
    const openDeleteModal = () => {
      showModal.value = false;
      showDeleteModal.value.display = true;
    };
    const closeDeleteModal = () => {
      showDeleteModal.value.display = false;
      showModal.value = true;
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", null, [
        createVNode(_sfc_main$n, {
          title: unref(it)("wallet.transactions.note.deleteModal.title"),
          caption: unref(it)("wallet.transactions.note.deleteModal.caption"),
          "show-modal": showDeleteModal.value,
          onClose: closeDeleteModal,
          onCancel: closeDeleteModal,
          onConfirm: onDelete
        }, null, 8, ["title", "caption", "show-modal"]),
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          "full-width-on-mobile": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$4, [
              createBaseVNode("div", _hoisted_2$4, toDisplayString(deletable.value ? unref(it)("wallet.transactions.note.edit") : unref(it)("wallet.transactions.note.add")), 1)
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_3$3, [
              withDirectives(createBaseVNode("textarea", {
                class: "col-span-12 h-full flex-1 w-full cc-py cc-text-color cc-area-light outline-none focus:outline-none focus:ring-0 ring-0 border-0 hover:ring-0 resize-none",
                "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => textInput.value = $event)
              }, null, 512), [
                [vModelText, textInput.value]
              ])
            ])
          ]),
          footer: withCtx(() => [
            createBaseVNode("div", _hoisted_4$3, [
              deletable.value ? (openBlock(), createBlock(_sfc_main$o, {
                key: 0,
                label: unref(it)("wallet.transactions.note.delete"),
                link: openDeleteModal,
                class: "col-start-1 col-span-6 lg:col-start-7 lg:col-span-3"
              }, null, 8, ["label"])) : createCommentVNode("", true),
              createVNode(_sfc_main$o, {
                label: confirmLabel.value,
                link: onConfirm,
                class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
              }, null, 8, ["label"])
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$3 = {
  key: 0,
  class: "relative"
};
const _hoisted_2$3 = { class: "relative w-full flex flex-row flex-nowrap justify-start" };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "GridTxListNote",
  props: {
    txHash: { type: String, required: true }
  },
  setup(__props) {
    const props = __props;
    const { txHash } = toRefs(props);
    const { hasSelectedAccount } = useSelectedAccount();
    const { it } = useTranslation();
    const { formatDatetime } = useFormatter();
    const showModal = ref(false);
    const txBalance = computed(() => getTxBalance(txHash.value));
    const txNote = computed(() => {
      var _a;
      return ((_a = txBalance.value) == null ? void 0 : _a.note) ?? null;
    });
    const label = computed(() => {
      const note = txNote.value;
      if (note) {
        let label2 = it("wallet.transactions.note.edit") + " (last updated: ";
        if (note.updated) {
          label2 += formatDatetime(note.updated);
        } else {
          label2 += formatDatetime(note.created);
        }
        return label2 + ")";
      } else {
        return it("wallet.transactions.note.add");
      }
    });
    const _saveNote = async (note) => {
      if (!txHash.value) {
        return;
      }
      try {
        await saveTxNote(txHash.value, note);
      } catch (err) {
        console.error("saveNote: " + ((err == null ? void 0 : err.message) ?? JSON.stringify(err)));
      }
      showModal.value = false;
    };
    const onSaveNote = (event) => _saveNote({ note: event.text, created: now() });
    const doDeleteNote = () => _saveNote(null);
    const onOpenModal = () => {
      showModal.value = true;
    };
    const onCloseModal = () => {
      showModal.value = false;
    };
    return (_ctx, _cache) => {
      return unref(hasSelectedAccount) ? (openBlock(), createElementBlock("div", _hoisted_1$3, [
        createBaseVNode("div", _hoisted_2$3, [
          createBaseVNode("div", {
            class: "relative cursor-pointer px-2 py-1 rounded cc-tabs-button text-right",
            onClick: onOpenModal
          }, [
            _cache[0] || (_cache[0] = createBaseVNode("i", { class: "text-sm mr-2 mdi mdi-note" }, null, -1)),
            createBaseVNode("span", null, toDisplayString(label.value), 1),
            createVNode(_sfc_main$h, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(label.value) + " " + toDisplayString(unref(txHash)), 1)
              ]),
              _: 1
            })
          ])
        ]),
        showModal.value ? (openBlock(), createBlock(_sfc_main$4, {
          key: 0,
          note: txNote.value,
          onConfirm: onSaveNote,
          onClose: onCloseModal,
          onDelete: doDeleteNote
        }, null, 8, ["note"])) : createCommentVNode("", true)
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$2 = {
  key: 0,
  class: "relative w-full"
};
const _hoisted_2$2 = { class: "cc-text-sm" };
const _hoisted_3$2 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_4$2 = { class: "flex flex-row flex-nowrap cc-text-xs" };
const _hoisted_5$2 = { class: "cc-text-semi-bold mr-4" };
const _hoisted_6$1 = { class: "w-full pb-1 pr-1 whitespace-pre-wrap overflow-auto" };
const _hoisted_7$1 = {
  key: 1,
  class: "relative w-full"
};
const _hoisted_8$1 = { class: "cc-text-sm" };
const _hoisted_9$1 = { class: "whitespace-nowrap cc-text-semi-bold" };
const _hoisted_10$1 = { class: "flex flex-row flex-nowrap cc-text-xs" };
const _hoisted_11$1 = { class: "cc-text-semi-bold mr-4" };
const _hoisted_12$1 = { class: "w-full pb-1 pr-1 whitespace-pre-wrap overflow-auto" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GridTxListGovernance",
  props: {
    tx: { type: Object, required: true }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const open = ref(false);
    const procedureCount = computed(() => {
      var _a;
      return (((_a = props.tx) == null ? void 0 : _a.body.voting_procedures) ?? []).length;
    });
    const proposalCount = computed(() => {
      var _a;
      return (((_a = props.tx) == null ? void 0 : _a.body.voting_proposals) ?? []).length;
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        proposalCount.value > 0 ? (openBlock(), createElementBlock("div", _hoisted_1$2, [
          createVNode(GridSpace, {
            hr: "",
            class: "w-full my-2"
          }),
          createBaseVNode("div", _hoisted_2$2, [
            createBaseVNode("div", {
              class: "flex flex-row flex-nowrap items-center cursor-pointer",
              onClick: _cache[0] || (_cache[0] = withModifiers(($event) => open.value = !open.value, ["prevent", "stop"]))
            }, [
              createBaseVNode("div", _hoisted_3$2, toDisplayString(proposalCount.value + " " + unref(t)("wallet.transactions.header.governance.proposal.label")), 1),
              createBaseVNode("i", {
                class: normalizeClass(["text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
              }, null, 2)
            ]),
            open.value ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(__props.tx.body.voting_proposals, (proposal, index) => {
              return openBlock(), createElementBlock("div", {
                class: "relative cc-rounded cc-bg-txdetails my-1 p-1 px-2",
                key: index
              }, [
                createBaseVNode("div", _hoisted_4$2, [
                  createBaseVNode("div", _hoisted_5$2, [
                    createTextVNode(toDisplayString(unref(t)("wallet.transactions.header.governance.proposal.action")) + " ", 1),
                    createVNode(_sfc_main$h, {
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.hover")), 1)
                      ]),
                      _: 1
                    })
                  ]),
                  createVNode(_sfc_main$g, {
                    label: Object.keys(proposal.governance_action)[0].replace("Action", ""),
                    "label-hover": unref(t)("wallet.transactions.button.copy.json.hover"),
                    "notification-text": unref(t)("wallet.transactions.button.copy.json.notify"),
                    "copy-text": JSON.stringify(proposal, null, 2),
                    showCopiedContent: false,
                    class: "inline-flex items-center justify-center"
                  }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
                ]),
                createBaseVNode("div", _hoisted_6$1, [
                  createVNode(unref(S), {
                    class: "w-full font-mono",
                    showLength: "",
                    showDoubleQuotes: false,
                    deep: 5,
                    data: proposal
                  }, null, 8, ["data"])
                ])
              ]);
            }), 128)) : createCommentVNode("", true)
          ])
        ])) : createCommentVNode("", true),
        procedureCount.value > 0 ? (openBlock(), createElementBlock("div", _hoisted_7$1, [
          createVNode(GridSpace, {
            hr: "",
            class: "w-full my-2"
          }),
          createBaseVNode("div", _hoisted_8$1, [
            createBaseVNode("div", {
              class: "flex flex-row flex-nowrap items-center cursor-pointer",
              onClick: _cache[1] || (_cache[1] = withModifiers(($event) => open.value = !open.value, ["prevent", "stop"]))
            }, [
              createBaseVNode("div", _hoisted_9$1, toDisplayString(procedureCount.value + " " + unref(t)("wallet.transactions.header.governance.procedure.label")), 1),
              createBaseVNode("i", {
                class: normalizeClass(["text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
              }, null, 2)
            ]),
            open.value ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(__props.tx.body.voting_procedures, (procedure, index) => {
              return openBlock(), createElementBlock("div", {
                class: "relative cc-rounded cc-bg-txdetails my-1 p-1 px-2",
                key: index
              }, [
                createBaseVNode("div", _hoisted_10$1, [
                  createBaseVNode("div", _hoisted_11$1, [
                    createTextVNode(toDisplayString(unref(t)("wallet.transactions.header.governance.procedure.voter")) + " ", 1),
                    createVNode(_sfc_main$h, {
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.json.hover")), 1)
                      ]),
                      _: 1
                    })
                  ]),
                  createVNode(_sfc_main$g, {
                    label: Object.keys(procedure.voter)[0],
                    "label-hover": unref(t)("wallet.transactions.button.copy.json.hover"),
                    "notification-text": unref(t)("wallet.transactions.button.copy.json.notify"),
                    "copy-text": JSON.stringify(procedure, null, 2),
                    showCopiedContent: false,
                    class: "inline-flex items-center justify-center"
                  }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
                ]),
                createBaseVNode("div", _hoisted_12$1, [
                  createVNode(unref(S), {
                    class: "w-full font-mono",
                    showLength: "",
                    showDoubleQuotes: false,
                    deep: 5,
                    data: procedure
                  }, null, 8, ["data"])
                ])
              ]);
            }), 128)) : createCommentVNode("", true)
          ])
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$1 = {
  key: 0,
  class: "relative w-full flex flex-col flex-nowrap justify-between items-start pt-0.5 top-3.5"
};
const _hoisted_2$1 = { class: "relative w-full flex flex-col sm:flex-row sm:flex-nowrap" };
const _hoisted_3$1 = { class: "relative flex flex-col flex-nowrap flex-1 w-full sm:w-1/2 sm:pr-2" };
const _hoisted_4$1 = { class: "relative flex flex-col flex-nowrap flex-1 w-full sm:w-1/2" };
const _hoisted_5$1 = { class: "w-full flex flex-row gap-1 justify-between" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridTxListDetails",
  props: {
    txBalance: { type: Object, required: true },
    tx: { type: Object, required: false, default: void 0 },
    accountId: { type: String, required: false, default: "" },
    msg: { type: Array, required: false, default: [] },
    isMsgEnc: { type: Boolean, required: false, default: false },
    witnessCheck: { type: Boolean, required: false, default: false },
    stagingTx: { type: Boolean, required: false, default: false },
    txViewer: { type: Boolean, required: false, default: false }
  },
  emits: ["loaded", "scamAddressFound"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const {
      txBalance,
      tx
    } = toRefs(props);
    const { t, c } = useTranslation();
    useQuasar();
    const { showTxDetails } = useDetailedTxInfo();
    const { showReportDetails } = useReportDetails();
    const {
      parseWitnesses,
      getVkeyWitnessHashList
    } = useWitnesses();
    const error = ref("");
    const txJson = ref(props.tx ?? null);
    const nativeScriptList = ref([]);
    const plutusContractList = ref([]);
    const blockNo = ref(0);
    const blockHash = ref("");
    const inputUtxoList = ref([]);
    const inputRefUtxoList = ref([]);
    const inputColUtxoList = ref([]);
    const isLoading = ref(true);
    const hasAnyUtxo = computed(
      () => {
        var _a, _b;
        return inputColUtxoList.value.length > 0 || inputRefUtxoList.value.length > 0 || inputUtxoList.value.length > 0 || ((_a = txJson.value) == null ? void 0 : _a.body.collateral_return) || (((_b = txJson.value) == null ? void 0 : _b.body.outputs.length) ?? 0) > 0;
      }
    );
    const fillUtxoList = (inputList, list, availableList) => {
      list.length = 0;
      if (inputList) {
        for (const input of inputList) {
          for (const utxo of availableList) {
            if (utxo.input.transaction_id === input.transaction_id && utxo.input.index === input.index) {
              list.push(utxo);
              break;
            }
          }
        }
      }
    };
    const update = async (balance, tx2) => {
      parseWitnesses(tx2);
      if (props.txViewer) {
        console.log("Vkey hashes:", getVkeyWitnessHashList());
      }
      try {
        if (!!balance.hash && !props.stagingTx) {
          const txCborList = await loadTxCbor(networkId.value, null, balance.hash);
          if (!txCborList || txCborList.length === 0) {
            const txByronList = await loadTxByron(networkId.value, null, balance.hash);
            if (!txByronList || txByronList.length === 0) {
              throw Error("Failed to fetch transaction details!");
            }
            blockNo.value = txByronList[0].bn;
            blockHash.value = txByronList[0].bh;
            txJson.value = createTransactionJSONFromITxByron(txByronList[0]);
            const _inputUtxoList = [];
            for (const input of txByronList[0].il) {
              _inputUtxoList.push(createIUtxoFromIUtxoDetails(input));
            }
            inputUtxoList.value = _inputUtxoList;
            return;
          }
          blockNo.value = txCborList[0].block;
          blockHash.value = txCborList[0].blockHash;
          const free = [];
          const txBuiltRes = getTransactionFromCbor(networkId.value, txCborList[0].cbor, 0, free);
          const cslNS = txBuiltRes.cslWitnessSet.native_scripts();
          cslNS ? free.push(cslNS) : false;
          if (cslNS) {
            for (let i = 0; i < cslNS.len(); i++) {
              const script = cslNS.get(i);
              free.push(script);
              const scriptHash = script.hash();
              free.push(scriptHash);
              nativeScriptList.value.push({
                scriptHash: toHexString(scriptHash.to_bytes()),
                json: cslToJson(script.to_json())
              });
            }
          }
          await updateTxJson(txBuiltRes.builtTx, txCborList[0].slot);
          freeCSLObjects(free);
        } else if (tx2) {
          updateTxJson(tx2);
        }
      } catch (err) {
        console.error((err == null ? void 0 : err.message) ?? JSON.stringify(err));
        error.value = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
      }
      isLoading.value = false;
    };
    const updateTxJson = async (tx2, slot) => {
      if (!tx2) {
        txJson.value = null;
        return;
      }
      txJson.value = tx2;
      try {
        tx2.inputUtxoList = tx2.inputUtxoList ?? [];
        await loadUnknownUtxos(networkId.value, tx2.inputUtxoList, getAllInputUtxoHashList(tx2));
        fillUtxoList(txJson.value.body.reference_inputs, inputRefUtxoList.value, tx2.inputUtxoList);
        fillUtxoList(txJson.value.body.collateral, inputColUtxoList.value, tx2.inputUtxoList);
        fillUtxoList(txJson.value.body.inputs, inputUtxoList.value, tx2.inputUtxoList);
        await parseWitnessSetPlutus(tx2, slot);
        emit("loaded");
      } catch (err) {
        error.value = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
      }
    };
    const parseWitnessSetPlutus = async (tx2, slot) => {
      var _a;
      plutusContractList.value.length = 0;
      if (tx2.witness_set.redeemers == null) {
        return;
      }
      const epochNo = slot ? getEpochFromSlot(networkId.value, slot) : chainTip.value.epochNo;
      let ep = null;
      if (chainTip.value.epochNo === epochNo) {
        ep = checkEpochParams();
      } else {
        const epList = await syncEpochParams(networkId.value, "txDetails", [epochNo]);
        if (epList) {
          ep = epList[0];
        }
      }
      const sortedInputList = ((_a = inputUtxoList.value) == null ? void 0 : _a.concat().sort((a, b) => a.input.transaction_id.localeCompare(b.input.transaction_id, "en-US") || a.input.index - b.input.index)) ?? [];
      for (const redeemer of tx2.witness_set.redeemers) {
        if (redeemer) {
          const isSpend = redeemer.tag === "Spend";
          const isMint = redeemer.tag === "Mint";
          const purpose = isMint ? "Mint" : redeemer.tag.toString();
          if (!isSpend && !isMint) {
            continue;
          }
          try {
            const redeemerData = getPlutusHVB(redeemer.data);
            const redeemerIndex = parseInt(redeemer.index);
            const redeemerInput = isSpend ? sortedInputList[redeemerIndex] : null;
            const inputCred = isSpend && redeemerInput ? getAddressCredentials(redeemerInput.output.address) : null;
            const mintHashList = isMint && tx2.body.mint ? tx2.body.mint.map((m) => m[0]) : [];
            const mintCred = mintHashList[redeemerIndex] ?? "";
            const prices = ep == null ? void 0 : ep.executionUnitPrices;
            const steps = redeemer.ex_units.steps;
            const mem = redeemer.ex_units.mem;
            let plutusScript = null;
            if (tx2.witness_set.plutus_scripts) {
              const cslPlutusScripts = PlutusScripts.from_json(jsonToCsl(tx2.witness_set.plutus_scripts));
              for (let i = 0; i < cslPlutusScripts.len(); i++) {
                const cslPlutusScript = cslPlutusScripts.get(i);
                const cslPlutusScriptHash = cslPlutusScript.hash();
                const plutusScriptHash = toHexString(cslPlutusScriptHash.to_bytes());
                if (isSpend && plutusScriptHash === (inputCred == null ? void 0 : inputCred.paymentCred) || isMint && plutusScriptHash === mintCred) {
                  plutusScript = {
                    hash: plutusScriptHash,
                    bytes: toHexString(cslPlutusScript.bytes()),
                    size: cslPlutusScript.bytes().byteLength
                  };
                }
                safeFreeCSLObject(cslPlutusScriptHash);
                safeFreeCSLObject(cslPlutusScript);
                if (plutusScript) {
                  break;
                }
              }
              safeFreeCSLObject(cslPlutusScripts);
            }
            if (!plutusScript) {
              for (const refInput of tx2.body.reference_inputs ?? []) {
                const _input = sortedInputList.find((input) => input.input.transaction_id === refInput.transaction_id && input.input.index === refInput.index);
                if ((_input == null ? void 0 : _input.output.script_ref) && _input.output.script_ref.hasOwnProperty("PlutusScript")) {
                  const pScript = _input.output.script_ref.PlutusScript;
                  const cslPlutusScript = PlutusScript.from_hex(pScript);
                  const cslPlutusScriptHash = cslPlutusScript.hash();
                  const plutusScriptHash = toHexString(cslPlutusScriptHash.to_bytes());
                  safeFreeCSLObject(cslPlutusScriptHash);
                  safeFreeCSLObject(cslPlutusScript);
                  if (isSpend && plutusScriptHash === (inputCred == null ? void 0 : inputCred.paymentCred) || isMint && plutusScriptHash === mintCred) {
                    plutusScript = {
                      hash: plutusScriptHash,
                      bytes: pScript,
                      size: toHexBuffer(pScript).byteLength
                    };
                    break;
                  }
                }
              }
            }
            const plutusDataList = [];
            if (tx2.witness_set.plutus_data) {
              if (tx2.witness_set.plutus_data.hasOwnProperty("elems") && !Array.isArray(tx2.witness_set.plutus_data.elems)) {
                const pDataList = tx2.witness_set.plutus_data.elems;
                for (const pDataJson of pDataList) {
                  const pData = getPlutusHVB(pDataJson);
                  if (pData) {
                    plutusDataList.push(pData);
                  }
                }
              }
            }
            let inputDatum;
            if (isSpend && (redeemerInput == null ? void 0 : redeemerInput.output.plutus_data)) {
              const hbv = getPlutusHVB(redeemerInput.output.plutus_data);
              if (hbv.value === null && hbv.hash) {
                const pData = plutusDataList.find((pd) => pd.hash === hbv.hash);
                inputDatum = {
                  hash: hbv.hash,
                  bytes: hbv.bytes ?? (pData == null ? void 0 : pData.bytes) ?? "",
                  value: hbv.value ?? (pData == null ? void 0 : pData.value) ?? ""
                };
              }
            }
            const contract = {
              address: (redeemerInput == null ? void 0 : redeemerInput.output.address) ?? null,
              scriptHash: (plutusScript == null ? void 0 : plutusScript.hash) ?? "",
              bytecode: (plutusScript == null ? void 0 : plutusScript.bytes) ?? "",
              size: (plutusScript == null ? void 0 : plutusScript.size) ?? 0,
              validContract: true,
              input: {
                redeemer: {
                  purpose,
                  fee: prices ? round(add(multiply(prices.steps, steps), multiply(prices.memory, mem)), 0, "up") : "-1",
                  unit: {
                    steps,
                    mem
                  },
                  datum: redeemerData
                },
                datum: void 0
              }
            };
            if (inputDatum) {
              contract.input.datum = inputDatum;
            }
            plutusContractList.value.push(contract);
          } catch (e) {
            console.error("Error: parseWitnessSetPlutus", e);
          }
        }
      }
    };
    const scamAddressFound = () => {
      emit("scamAddressFound");
    };
    watch(txBalance, () => {
      update(txBalance.value, props.tx);
    }, { deep: true });
    watch(() => props.tx, () => {
      update(txBalance.value, props.tx);
    }, { deep: true });
    onMounted(() => {
      update(txBalance.value, props.tx);
    });
    onUnmounted(() => {
      update(txBalance.value, props.tx);
    });
    return (_ctx, _cache) => {
      var _a, _b, _c, _d, _e, _f, _g;
      return !txJson.value || !unref(txBalance) ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
        !__props.txViewer ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          class: "w-full mt-0.5 mb-2"
        })) : createCommentVNode("", true),
        createVNode(_sfc_main$p, {
          active: !txJson.value,
          class: "mb-3 w-full"
        }, null, 8, ["active"])
      ])) : txJson.value && unref(txBalance) ? (openBlock(), createElementBlock("div", {
        key: 1,
        class: normalizeClass(["relative w-full flex flex-col flex-nowrap justify-between items-start pt-0.5", __props.stagingTx ? "mt-1" : "mt-3.5"])
      }, [
        !__props.txViewer ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          class: "w-full mt-0.5 mb-2"
        })) : createCommentVNode("", true),
        createVNode(_sfc_main$c, {
          tx: txJson.value,
          hash: (_a = unref(txBalance)) == null ? void 0 : _a.hash,
          blockNo: blockNo.value,
          blochHash: blockHash.value,
          inputUtxoList: inputUtxoList.value,
          "staging-tx": __props.stagingTx
        }, null, 8, ["tx", "hash", "blockNo", "blochHash", "inputUtxoList", "staging-tx"]),
        createVNode(_sfc_main$7, {
          tx: txJson.value
        }, null, 8, ["tx"]),
        txJson.value.body.withdrawals ? (openBlock(), createBlock(_sfc_main$b, {
          key: 1,
          tx: txJson.value,
          "tx-viewer": __props.txViewer,
          hash: (_b = unref(txBalance)) == null ? void 0 : _b.hash,
          "account-id": __props.accountId
        }, null, 8, ["tx", "tx-viewer", "hash", "account-id"])) : createCommentVNode("", true),
        txJson.value.body.certs ? (openBlock(), createBlock(_sfc_main$9, {
          key: 2,
          tx: txJson.value
        }, null, 8, ["tx"])) : createCommentVNode("", true),
        nativeScriptList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$6, {
          key: 3,
          scriptList: nativeScriptList.value
        }, null, 8, ["scriptList"])) : createCommentVNode("", true),
        createVNode(_sfc_main$5, {
          "contract-list": plutusContractList.value,
          tx: txJson.value,
          isLoading: isLoading.value
        }, null, 8, ["contract-list", "tx", "isLoading"]),
        createVNode(_sfc_main$8, {
          tx: txJson.value,
          "decrypted-msg": __props.isMsgEnc && __props.msg.length > 0 ? __props.msg : void 0
        }, null, 8, ["tx", "decrypted-msg"]),
        createVNode(_sfc_main$a, {
          tx: txJson.value,
          witnessCheck: __props.witnessCheck
        }, null, 8, ["tx", "witnessCheck"]),
        createVNode(_sfc_main$2, {
          tx: txJson.value
        }, null, 8, ["tx"]),
        hasAnyUtxo.value ? (openBlock(), createBlock(GridSpace, {
          key: 4,
          hr: "",
          class: "w-full mt-2"
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_2$1, [
          createBaseVNode("div", _hoisted_3$1, [
            inputColUtxoList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$d, {
              key: 0,
              label: unref(t)("wallet.transactions.header.utxo.collateralInputs"),
              "utxo-list": inputColUtxoList.value,
              "account-id": __props.accountId,
              "tx-hash": ((_c = unref(txBalance)) == null ? void 0 : _c.hash) ?? "",
              "is-input": "",
              witnessCheck: __props.witnessCheck,
              "tx-viewer": __props.txViewer,
              onScamAddressFound: scamAddressFound
            }, null, 8, ["label", "utxo-list", "account-id", "tx-hash", "witnessCheck", "tx-viewer"])) : createCommentVNode("", true),
            inputRefUtxoList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$d, {
              key: 1,
              label: unref(t)("wallet.transactions.header.utxo.referenceInputs"),
              "utxo-list": inputRefUtxoList.value,
              "account-id": __props.accountId,
              "tx-hash": ((_d = unref(txBalance)) == null ? void 0 : _d.hash) ?? "",
              "is-input": "",
              witnessCheck: __props.witnessCheck,
              "tx-viewer": __props.txViewer,
              onScamAddressFound: scamAddressFound
            }, null, 8, ["label", "utxo-list", "account-id", "tx-hash", "witnessCheck", "tx-viewer"])) : createCommentVNode("", true),
            inputUtxoList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$d, {
              key: 2,
              label: unref(t)("wallet.transactions.header.utxo.inputs"),
              "utxo-list": inputUtxoList.value,
              "account-id": __props.accountId,
              "tx-hash": ((_e = unref(txBalance)) == null ? void 0 : _e.hash) ?? "",
              "is-input": "",
              witnessCheck: __props.witnessCheck,
              "tx-viewer": __props.txViewer,
              onScamAddressFound: scamAddressFound
            }, null, 8, ["label", "utxo-list", "account-id", "tx-hash", "witnessCheck", "tx-viewer"])) : createCommentVNode("", true)
          ]),
          createBaseVNode("div", _hoisted_4$1, [
            txJson.value.body.collateral_return ? (openBlock(), createBlock(_sfc_main$d, {
              key: 0,
              label: unref(t)("wallet.transactions.header.utxo.collateralOutput"),
              "utxo-list": [unref(createIUtxo)({ output: txJson.value.body.collateral_return })],
              "account-id": __props.accountId,
              "tx-hash": ((_f = unref(txBalance)) == null ? void 0 : _f.hash) ?? "",
              witnessCheck: __props.witnessCheck,
              "tx-viewer": __props.txViewer,
              onScamAddressFound: scamAddressFound
            }, null, 8, ["label", "utxo-list", "account-id", "tx-hash", "witnessCheck", "tx-viewer"])) : createCommentVNode("", true),
            txJson.value.body.outputs.length > 0 ? (openBlock(), createBlock(_sfc_main$d, {
              key: 1,
              label: unref(t)("wallet.transactions.header.utxo.outputs"),
              "utxo-list": txJson.value.body.outputs.map((o) => unref(createIUtxo)({ output: o })),
              "account-id": __props.accountId,
              "tx-hash": ((_g = unref(txBalance)) == null ? void 0 : _g.hash) ?? "",
              witnessCheck: __props.witnessCheck,
              "tx-viewer": __props.txViewer,
              onScamAddressFound: scamAddressFound
            }, null, 8, ["label", "utxo-list", "account-id", "tx-hash", "witnessCheck", "tx-viewer"])) : createCommentVNode("", true)
          ])
        ]),
        createVNode(GridSpace, {
          class: "relative w-full my-2",
          hr: ""
        }),
        createBaseVNode("div", _hoisted_5$1, [
          unref(txBalance) && !__props.stagingTx ? (openBlock(), createBlock(_sfc_main$3, {
            key: 0,
            "tx-hash": unref(txBalance).hash
          }, null, 8, ["tx-hash"])) : createCommentVNode("", true),
          _cache[4] || (_cache[4] = createBaseVNode("div", { class: "grow" }, " ", -1)),
          createBaseVNode("button", {
            class: normalizeClass(["cursor-pointer px-2 py-0 rounded cc-tabs-button", unref(showReportDetails) ? "cc-tabs-button-active" : ""]),
            onClick: _cache[0] || (_cache[0] = ($event) => showReportDetails.value = !unref(showReportDetails))
          }, _cache[2] || (_cache[2] = [
            createBaseVNode("i", { class: "mdi mdi-list-box-outline text-lg" }, null, -1)
          ]), 2),
          createBaseVNode("button", {
            class: normalizeClass(["cursor-pointer px-2 py-0 rounded cc-tabs-button", unref(showTxDetails) ? "cc-tabs-button-active" : ""]),
            onClick: _cache[1] || (_cache[1] = ($event) => showTxDetails.value = !unref(showTxDetails))
          }, _cache[3] || (_cache[3] = [
            createBaseVNode("i", { class: "mdi mdi-information-outline text-lg" }, null, -1)
          ]), 2)
        ])
      ], 2)) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1 = { class: "cc-grid" };
const _hoisted_2 = { class: "h-full pr-1 flex flex-col self-start" };
const _hoisted_3 = { class: "cc-flex-fixed flex flex-row flex-nowrap items-start" };
const _hoisted_4 = {
  key: 0,
  class: "relative cc-flex-fixed flex flex-col flex-nowrap items-start w-6 h-6"
};
const _hoisted_5 = {
  key: 1,
  class: "relative cc-flex-fixed flex flex-col flex-nowrap items-start w-6 h-6 -ml-1 mr-1"
};
const _hoisted_6 = { class: "relative flex flex-row items-center mt-1 sm:mt-0.5 gap-1" };
const _hoisted_7 = {
  key: 0,
  class: "mdi mdi-note mr-1"
};
const _hoisted_8 = { key: 1 };
const _hoisted_9 = { class: "cc-none inline-flex justify-center" };
const _hoisted_10 = {
  key: 0,
  class: "mdi mdi-progress-check text-amber-700 dark:text-amber-500"
};
const _hoisted_11 = {
  key: 1,
  class: "mdi mdi-progress-check text-green-700 dark:text-green-500"
};
const _hoisted_12 = {
  key: 2,
  class: "mdi mdi-check text-green-700 dark:text-green-500"
};
const _hoisted_13 = {
  key: 2,
  class: "relative cc-text-bold mr-0.5"
};
const _hoisted_14 = {
  key: 3,
  class: "relative cc-text-bold mr-0.5"
};
const _hoisted_15 = {
  key: 0,
  class: "text-italic"
};
const _hoisted_16 = { key: 4 };
const _hoisted_17 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_18 = { key: 5 };
const _hoisted_19 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_20 = { key: 6 };
const _hoisted_21 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_22 = { key: 7 };
const _hoisted_23 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_24 = { key: 8 };
const _hoisted_25 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_26 = { key: 9 };
const _hoisted_27 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_28 = { key: 10 };
const _hoisted_29 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_30 = { key: 11 };
const _hoisted_31 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_32 = { key: 12 };
const _hoisted_33 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_34 = { key: 13 };
const _hoisted_35 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_36 = { key: 14 };
const _hoisted_37 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_38 = { key: 16 };
const _hoisted_39 = { class: "cc-badge-blue cc-none inline-flex" };
const _hoisted_40 = { key: 17 };
const _hoisted_41 = { class: "cc-badge-gray cc-none inline-flex" };
const _hoisted_42 = { class: "cc-badge-yellow cc-none inline-flex" };
const _hoisted_43 = { key: 19 };
const _hoisted_44 = { class: "cc-badge-red cc-none inline-flex" };
const _hoisted_45 = { key: 20 };
const _hoisted_46 = { class: "cc-badge-green cc-none inline-flex" };
const _hoisted_47 = { key: 21 };
const _hoisted_48 = { class: "cc-badge-red cc-none inline-flex" };
const _hoisted_49 = { key: 22 };
const _hoisted_50 = { class: "cc-badge-red cc-none inline-flex" };
const _hoisted_51 = { key: 23 };
const _hoisted_52 = { class: "cc-badge-purple cc-none inline-flex" };
const _hoisted_53 = { key: 24 };
const _hoisted_54 = { class: "cc-badge-yellow cc-none inline-flex" };
const _hoisted_55 = { key: 25 };
const _hoisted_56 = { class: "cc-badge-yellow cc-none inline-flex" };
const _hoisted_57 = { key: 26 };
const _hoisted_58 = { class: "cc-badge-yellow cc-none inline-flex" };
const _hoisted_59 = { key: 27 };
const _hoisted_60 = { class: "cc-badge-gray cc-none inline-flex" };
const _hoisted_61 = { key: 28 };
const _hoisted_62 = { class: "cc-badge-gray cc-none inline-flex" };
const _hoisted_63 = { key: 29 };
const _hoisted_64 = { class: "cc-badge-red cc-none inline-flex" };
const _hoisted_65 = { key: 30 };
const _hoisted_66 = {
  key: 0,
  class: "ml-6 mt-1 cc-addr break-normal"
};
const _hoisted_67 = {
  key: 1,
  class: "ml-6 mt-1 cc-addr break-normal"
};
const _hoisted_68 = {
  key: 2,
  class: "ml-6 mt-1 cc-addr break-normal text-italic"
};
const _hoisted_69 = { class: "ml-6 mt-1 cc-addr flex flex-col flex-nowrap break-all" };
const _hoisted_70 = {
  key: 0,
  class: "inline italic"
};
const _hoisted_71 = {
  key: 1,
  class: "flex flex-col flex-nowrap break-all"
};
const _hoisted_72 = {
  key: 0,
  class: "inline"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridTxListBalance",
  props: {
    txBalance: { type: Object, required: true },
    tx: { type: Object, required: false, default: void 0 },
    accountId: { type: String, required: false, default: "" },
    alwaysOpen: { type: Boolean, required: false, default: false },
    isOpen: { type: Boolean, required: false, default: false },
    witnessCheck: { type: Boolean, required: false, default: false },
    stagingTx: { type: Boolean, required: false, default: false },
    pendingTx: { type: Boolean, required: false, default: false },
    signed: { type: Boolean, required: false, default: false },
    txViewer: { type: Boolean, required: false, default: false },
    sendTx: { type: Boolean, required: false, default: false },
    isLastItem: { type: Boolean, required: false, default: false }
  },
  emits: ["deleteNote", "addNote"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const storeId = "GridTxListBalance-" + getRandomId();
    const { t } = useTranslation();
    const { formatRemainingTime } = useFormatter();
    const $q = useQuasar();
    const {
      formatTxType,
      formatDatetime
    } = useFormatter();
    const {
      txBalance,
      accountId
    } = toRefs(props);
    const loaded = ref(false);
    const open = ref(props.isOpen);
    watch(() => props.isOpen, (value) => {
      open.value = value;
    });
    const txType = ref(formatTxType(txBalance.value.t, t));
    const isOnChain = computed(() => {
      var _a;
      return isOnChainState((_a = props.tx) == null ? void 0 : _a.state);
    });
    const isInvalid = computed(() => {
      var _a;
      return isInvalidState((_a = props.tx) == null ? void 0 : _a.state);
    });
    const isSubmitted = computed(() => {
      var _a;
      return isSubmittedState((_a = props.tx) == null ? void 0 : _a.state);
    });
    const isFailed = computed(() => {
      var _a, _b;
      return ((_a = props.txBalance) == null ? void 0 : _a.fsc) || ((_b = props.tx) == null ? void 0 : _b.is_valid) === false;
    });
    const hasCbor = computed(() => {
      var _a;
      return (_a = props.tx) == null ? void 0 : _a.cbor;
    });
    const isSigned = computed(() => {
      var _a;
      return isSignedState((_a = props.tx) == null ? void 0 : _a.state);
    });
    const ttl = computed(() => {
      var _a;
      return parseInt(((_a = props.tx) == null ? void 0 : _a.body.ttl) ?? "0");
    });
    const doesNotExpire = computed(() => ttl.value === 0);
    const currentSlot = computed(() => {
      timestamp.value;
      return getCalculatedChainTip(networkId.value);
    });
    const remainingSeconds = computed(() => {
      return ttl.value - currentSlot.value;
    });
    const validFor = computed(() => {
      if (ttl.value <= 0) {
        return "";
      }
      if (remainingSeconds.value <= 0) {
        return "expired";
      } else {
        return formatRemainingTime(remainingSeconds.value);
      }
    });
    const isExpired = computed(() => {
      if (ttl.value <= 0) {
        return false;
      }
      if (remainingSeconds.value <= 0) {
        return true;
      } else {
        return false;
      }
    });
    watch(isExpired, (value, oldValue) => {
      if (!oldValue && value) {
        dispatchSignal(doUpdatePendingTxStatus);
      }
    });
    const hasMeta = ref(false);
    const hasMint = ref(false);
    const hasRegCert = ref(false);
    const hasDeregCert = ref(false);
    const hasDelegCert = ref(false);
    const hasPoolRegCert = ref(false);
    const hasPoolRetCert = ref(false);
    const hasGovCert = ref(false);
    const hasGovVote = ref(false);
    const hasNativeScript = ref(false);
    const hasPlutusContract = ref(false);
    const hasCatalystReg = ref(false);
    const hasMilkomedaMeta = ref(false);
    const blockTime = ref(/* @__PURE__ */ new Date());
    const confirmations = ref(0);
    const hasNote = computed(() => {
      var _a;
      return ((_a = txBalance.value) == null ? void 0 : _a.note) ?? null;
    });
    const contractPropertyList = ref([]);
    const hasMoreComments = ref(false);
    const isCommentsEnc = ref(false);
    const encMessage = ref("");
    const encType = ref("");
    const showDecryptMsgModal = ref(false);
    const comments = ref([]);
    const commentsHeader = computed(() => comments.value.length > 4 ? comments.value.slice(0, 2) : comments.value.concat());
    const numComments = computed(() => comments.value.length);
    const getMessage = () => {
      const msg = txBalance.value.msg;
      const enc = txBalance.value.enc;
      if (msg && msg.length > 0) {
        let copy;
        if (enc && enc !== "plain") {
          isCommentsEnc.value = true;
          const decryptedMsg = txBalance.value.hash ? decryptedMsgMap.value.get(txBalance.value.hash) : null;
          if (decryptedMsg) {
            copy = [...decryptedMsg];
          } else {
            encMessage.value = msg.join("");
            encType.value = enc;
            copy = [];
          }
        } else {
          copy = msg.concat();
        }
        if (copy.length > 4) {
          hasMoreComments.value = true;
        }
        return copy;
      }
      return [];
    };
    const decryptMsg = async (password) => {
      const decrypted = await decryptMessage(encMessage.value, password, encType.value);
      if (Array.isArray(decrypted)) {
        if (decrypted.length > 4) {
          hasMoreComments.value = true;
        }
        comments.value = decrypted;
        await saveDecryptedMsg(txBalance.value.hash, decrypted);
      }
    };
    const onDecryptMsg = async () => {
      if (isCommentsEnc.value) {
        if (comments.value.length === 0) {
          try {
            await decryptMsg(DEFAULT_MSG_PASSWORD);
          } catch (e) {
            showDecryptMsgModal.value = true;
          }
        } else {
          await delDecryptedMsg(txBalance.value.hash);
          comments.value = getMessage();
        }
      }
    };
    const onDecryptMsgPassword = async (payload) => {
      showDecryptMsgModal.value = false;
      try {
        await decryptMsg(payload.password);
      } catch (e) {
        $q.notify({
          type: "negative",
          message: t("wallet.transactions.message.modal.error"),
          position: "top-left"
        });
      }
    };
    const checkOnChain = () => {
      var _a, _b;
      if ((((_a = txBalance.value) == null ? void 0 : _a.block) ?? 0) === 0) {
        return;
      }
      confirmations.value = chainTip.value.blockNo - (((_b = txBalance.value) == null ? void 0 : _b.block) ?? 0);
      if (confirmations.value >= 20) {
        removeSignalListener(onInterval60s, storeId);
      }
    };
    const onRemoveExpiredTx = () => {
      var _a, _b;
      if ((_a = txBalance == null ? void 0 : txBalance.value) == null ? void 0 : _a.hash) {
        dispatchSignal(doRemovePendingTx, (_b = txBalance == null ? void 0 : txBalance.value) == null ? void 0 : _b.hash);
      }
    };
    const submitTransaction = async () => {
      const tx = props.tx;
      if (!tx || !tx.cbor) {
        return;
      }
      const res = await submitTx(networkId.value, tx.cbor, tx);
      if (res.status === 200) {
        $q.notify({
          type: "positive",
          message: "tx successfully submitted",
          position: "top-left",
          timeout: 4e3
        });
      } else {
        $q.notify({
          type: "negative",
          message: res.error ?? "Unknown submit error: " + res.status,
          position: "top-left",
          timeout: 8e3
        });
      }
      console.warn(">>> submit: res", res);
    };
    watch(txBalance, async (balance) => {
      var _a;
      txType.value = formatTxType(balance.t, t);
      contractPropertyList.value = [];
      isCommentsEnc.value = false;
      hasMoreComments.value = false;
      comments.value.length = 0;
      encMessage.value = "";
      encType.value = "";
      hasCatalystReg.value = !!balance.mk && balance.mk.includes(61284);
      hasMilkomedaMeta.value = !!balance.mk && balance.mk.some((k) => k === 87 || k === 88);
      if (hasMilkomedaMeta.value) {
        const txCborList = await loadTxCbor(networkId.value, null, balance.hash);
        const free = [];
        if (txCborList && txCborList.length > 0) {
          const txBuiltRes = getTransactionFromCbor(networkId.value, txCborList[0].cbor, 0, free);
          if (!isMilkomedaTx(((_a = txBuiltRes.builtTx) == null ? void 0 : _a.auxiliary_data) ?? null, networkId.value)) {
            hasMilkomedaMeta.value = false;
          }
        }
      }
      if (balance.cert) {
        hasRegCert.value = balance.cert.some((c) => c === CertificateKind.StakeRegistration || c === CertificateKind.StakeRegistrationAndDelegation || c === CertificateKind.StakeVoteRegistrationAndDelegation || c === CertificateKind.DRepRegistration || c === CertificateKind.DRepUpdate);
        hasDeregCert.value = balance.cert.some((c) => c === CertificateKind.StakeDeregistration || c === CertificateKind.DRepDeregistration);
        hasDelegCert.value = balance.cert.some(
          (c) => c === CertificateKind.StakeDelegation || c === CertificateKind.VoteDelegation || c === CertificateKind.StakeRegistrationAndDelegation || c === CertificateKind.StakeAndVoteDelegation || c === CertificateKind.StakeVoteRegistrationAndDelegation || c === CertificateKind.VoteRegistrationAndDelegation
        );
        hasPoolRegCert.value = balance.cert.some((c) => c === CertificateKind.PoolRegistration);
        hasPoolRetCert.value = balance.cert.some((c) => c === CertificateKind.PoolRetirement);
        hasGovCert.value = balance.cert.some((c) => c === CertificateKind.VoteDelegation || c === CertificateKind.VoteRegistrationAndDelegation || c === CertificateKind.StakeAndVoteDelegation || c === CertificateKind.StakeVoteRegistrationAndDelegation || c === CertificateKind.CommitteeColdResign || c === CertificateKind.CommitteeHotAuth || c === CertificateKind.DRepRegistration || c === CertificateKind.DRepDeregistration || c === CertificateKind.DRepUpdate || c === CertificateKind.GenesisKeyDelegation);
      } else {
        hasRegCert.value = false;
        hasDeregCert.value = false;
        hasDelegCert.value = false;
        hasPoolRegCert.value = false;
        hasPoolRetCert.value = false;
        hasGovCert.value = false;
      }
      hasGovVote.value = balance.v ?? false;
      blockTime.value = new Date(getTimestampFromSlot(networkId.value, txBalance.value.slot));
      if (!!balance.block && balance.block > 0) {
        confirmations.value = chainTip.value.blockNo - balance.block;
      } else {
        confirmations.value = 0;
      }
      let addressList = balance.asl;
      if (accountId.value && !addressList && balance.al.length > 0) {
        addressList = await getAddressesByRefId(networkId.value, accountId.value, balance.al);
      }
      if (addressList && ((addressList == null ? void 0 : addressList.length) ?? 0) > 0) {
        contractPropertyList.value = getContractMappingByAddresses(addressList);
      }
      comments.value = getMessage();
      hasMeta.value = !!balance.mk && balance.mk.length > 0 && !(isCommentsEnc.value || numComments.value > 0) && contractPropertyList.value.length === 0;
      hasNativeScript.value = (balance.n ?? false) && contractPropertyList.value.length === 0;
      hasPlutusContract.value = (balance.p ?? false) && contractPropertyList.value.length === 0;
      hasMint.value = (balance.m ?? false) && contractPropertyList.value.length === 0;
    }, { immediate: true, deep: true });
    onMounted(async () => {
      addSignalListener(onInterval60s, storeId, checkOnChain);
      checkOnChain();
    });
    onUnmounted(() => {
      removeSignalListener(onInterval60s, storeId);
    });
    return (_ctx, _cache) => {
      var _a, _b, _c;
      return openBlock(), createElementBlock("div", _hoisted_1, [
        showDecryptMsgModal.value ? (openBlock(), createBlock(_sfc_main$q, {
          key: 0,
          "show-modal": showDecryptMsgModal.value,
          title: unref(t)("wallet.transactions.message.modal.label"),
          caption: unref(t)("wallet.transactions.message.modal.caption"),
          "submit-button-label": unref(t)("common.label.decrypt"),
          "text-id": "form.password.general",
          autofocus: "",
          onClose: _cache[0] || (_cache[0] = ($event) => showDecryptMsgModal.value = false),
          onSubmit: onDecryptMsgPassword
        }, null, 8, ["show-modal", "title", "caption", "submit-button-label"])) : createCommentVNode("", true),
        unref(txBalance) ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["relative col-span-12 cc-p pt-1.5 cc-text-sz flex flex-col flex-grow flex-nowrap", open.value || __props.alwaysOpen || __props.stagingTx || __props.pendingTx || __props.sendTx ? "cc-area-light" : ""])
        }, [
          !__props.txViewer ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: normalizeClass(["flex flex-row flex-nowrap justify-between items-start", __props.alwaysOpen ? "" : "cursor-pointer"]),
            onClick: _cache[1] || (_cache[1] = withModifiers(($event) => open.value = !open.value, ["stop"]))
          }, [
            !__props.alwaysOpen ? (openBlock(), createBlock(_sfc_main$h, {
              key: 0,
              anchor: "top middle",
              offset: [0, 0],
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(t)("wallet.transactions.button.txDetails." + (open.value ? "collapse" : "expand"))), 1)
              ]),
              _: 1
            })) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_2, [
              createBaseVNode("div", _hoisted_3, [
                (__props.stagingTx || __props.sendTx) && ((_a = unref(txBalance)) == null ? void 0 : _a.coin) === "0" ? (openBlock(), createElementBlock("div", _hoisted_4, _cache[3] || (_cache[3] = [
                  createBaseVNode("div", { class: "mt-1 rounded-full bg-yellow-500 dark:bg-yellow-600 w-4 h-4 flex justify-center items-center" }, [
                    createBaseVNode("i", { class: "mdi mdi-alert-octagon-outline text-xs" })
                  ], -1)
                ]))) : (openBlock(), createElementBlock("div", _hoisted_5, [
                  createBaseVNode("i", {
                    class: normalizeClass(["relative text-xl -mt-px", txType.value.icon])
                  }, null, 2),
                  !__props.alwaysOpen ? (openBlock(), createElementBlock("i", {
                    key: 0,
                    class: normalizeClass(["relative text-xl -top-1.5", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
                  }, null, 2)) : createCommentVNode("", true)
                ])),
                createBaseVNode("div", _hoisted_6, [
                  hasNote.value ? (openBlock(), createElementBlock("i", _hoisted_7)) : createCommentVNode("", true),
                  !__props.stagingTx && ((_b = unref(txBalance)) == null ? void 0 : _b.block) ? (openBlock(), createElementBlock("div", _hoisted_8, [
                    createBaseVNode("div", _hoisted_9, [
                      confirmations.value < 10 ? (openBlock(), createElementBlock("i", _hoisted_10)) : confirmations.value < 20 ? (openBlock(), createElementBlock("i", _hoisted_11)) : (openBlock(), createElementBlock("i", _hoisted_12)),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(Math.max(0, confirmations.value)) + " " + toDisplayString(confirmations.value === 1 ? unref(t)("wallet.transactions.confirmation") : unref(t)("wallet.transactions.confirmations")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.stagingTx || __props.sendTx) && ((_c = unref(txBalance)) == null ? void 0 : _c.coin) === "0" ? (openBlock(), createElementBlock("div", _hoisted_13, _cache[4] || (_cache[4] = [
                    createBaseVNode("span", { class: "text-italic" }, toDisplayString("Preview: Waiting for user inputs"), -1)
                  ]))) : (openBlock(), createElementBlock("div", _hoisted_14, [
                    __props.stagingTx || __props.sendTx ? (openBlock(), createElementBlock("span", _hoisted_15, toDisplayString("Preview: "))) : createCommentVNode("", true),
                    createTextVNode(toDisplayString(txType.value.name), 1)
                  ])),
                  hasCatalystReg.value ? (openBlock(), createElementBlock("div", _hoisted_16, [
                    createBaseVNode("div", _hoisted_17, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.catalyst.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.catalyst.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasMeta.value ? (openBlock(), createElementBlock("div", _hoisted_18, [
                    createBaseVNode("div", _hoisted_19, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.metadata.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.metadata.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasMint.value ? (openBlock(), createElementBlock("div", _hoisted_20, [
                    createBaseVNode("div", _hoisted_21, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.mint.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.mint.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasGovCert.value || hasGovVote.value ? (openBlock(), createElementBlock("div", _hoisted_22, [
                    createBaseVNode("div", _hoisted_23, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.gov.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.gov.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasGovVote.value ? (openBlock(), createElementBlock("div", _hoisted_24, [
                    createBaseVNode("div", _hoisted_25, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.vote.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.vote.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasRegCert.value ? (openBlock(), createElementBlock("div", _hoisted_26, [
                    createBaseVNode("div", _hoisted_27, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.reg.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.reg.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasDeregCert.value ? (openBlock(), createElementBlock("div", _hoisted_28, [
                    createBaseVNode("div", _hoisted_29, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.dereg.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.dereg.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasDelegCert.value ? (openBlock(), createElementBlock("div", _hoisted_30, [
                    createBaseVNode("div", _hoisted_31, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.delegation.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.delegation.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasPoolRegCert.value ? (openBlock(), createElementBlock("div", _hoisted_32, [
                    createBaseVNode("div", _hoisted_33, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.poolreg.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.poolreg.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasPoolRetCert.value ? (openBlock(), createElementBlock("div", _hoisted_34, [
                    createBaseVNode("div", _hoisted_35, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.poolret.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.poolret.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasNativeScript.value ? (openBlock(), createElementBlock("div", _hoisted_36, [
                    createBaseVNode("div", _hoisted_37, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.nativescript.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.nativescript.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  contractPropertyList.value.length > 0 ? (openBlock(true), createElementBlock(Fragment, { key: 15 }, renderList(contractPropertyList.value, (item, index) => {
                    return openBlock(), createElementBlock("div", { key: index }, [
                      (item.label !== "Milkomeda C1" ? true : !hasMilkomedaMeta.value) ? (openBlock(), createElementBlock("div", {
                        key: 0,
                        class: "cc-badge cc-none inline-flex",
                        style: normalizeStyle("color:" + item.color + " ; background-color: " + item.bgColor)
                      }, [
                        createTextVNode(toDisplayString(item.label) + " ", 1),
                        createVNode(_sfc_main$h, {
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(item.label), 1)
                          ]),
                          _: 2
                        }, 1024)
                      ], 4)) : createCommentVNode("", true)
                    ]);
                  }), 128)) : hasPlutusContract.value ? (openBlock(), createElementBlock("div", _hoisted_38, [
                    createBaseVNode("div", _hoisted_39, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.plutus.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.plutus.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.pendingTx || __props.stagingTx) && isSigned.value && !isSubmitted.value && !isOnChain.value ? (openBlock(), createElementBlock("div", _hoisted_40, [
                    createBaseVNode("div", _hoisted_41, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.signed.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.signed.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.pendingTx || __props.stagingTx) && isSigned.value && !isSubmitted.value && !isOnChain.value && hasCbor.value && !isInvalid.value ? (openBlock(), createElementBlock("div", {
                    key: 18,
                    onClick: withModifiers(submitTransaction, ["stop"])
                  }, [
                    createBaseVNode("div", _hoisted_42, [
                      _cache[6] || (_cache[6] = createTextVNode(" submit transaction ")),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => _cache[5] || (_cache[5] = [
                          createTextVNode(" Transaction isn't submitted yet. Click here to submit it. ")
                        ])),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.pendingTx || __props.stagingTx) && isSigned.value && !isSubmitted.value && !hasCbor.value ? (openBlock(), createElementBlock("div", _hoisted_43, [
                    createBaseVNode("div", _hoisted_44, [
                      _cache[8] || (_cache[8] = createTextVNode(" not submitted ")),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => _cache[7] || (_cache[7] = [
                          createTextVNode(" Transaction was signed, but not submitted. ")
                        ])),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.pendingTx || __props.stagingTx) && isOnChain.value ? (openBlock(), createElementBlock("div", _hoisted_45, [
                    createBaseVNode("div", _hoisted_46, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.onchain.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.onchain.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.pendingTx || __props.stagingTx) && isInvalid.value ? (openBlock(), createElementBlock("div", _hoisted_47, [
                    createBaseVNode("div", _hoisted_48, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.invalid.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.invalid.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  !(__props.pendingTx || __props.stagingTx) && isFailed.value ? (openBlock(), createElementBlock("div", _hoisted_49, [
                    createBaseVNode("div", _hoisted_50, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.failed.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.failed.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  hasMilkomedaMeta.value ? (openBlock(), createElementBlock("div", _hoisted_51, [
                    createBaseVNode("div", _hoisted_52, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.milkomeda.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.milkomeda.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.pendingTx || __props.stagingTx) && !isExpired.value && !isInvalid.value && !isOnChain.value && __props.pendingTx && isSubmitted.value ? (openBlock(), createElementBlock("div", _hoisted_53, [
                    createBaseVNode("div", _hoisted_54, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.pending.label")) + " ", 1),
                      createVNode(QSpinner_default, {
                        color: "white",
                        size: "1.0em",
                        thickness: 2,
                        class: "mt-px ml-1"
                      }),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.pending.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : __props.signed && !__props.pendingTx && !isExpired.value && !isInvalid.value && !isOnChain.value ? (openBlock(), createElementBlock("div", _hoisted_55, [
                    createBaseVNode("div", _hoisted_56, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.signed.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.signed.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : (__props.pendingTx || __props.stagingTx) && !isExpired.value && !isInvalid.value && !isOnChain.value && __props.stagingTx && !__props.sendTx ? (openBlock(), createElementBlock("div", _hoisted_57, [
                    createBaseVNode("div", _hoisted_58, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.staging.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.staging.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.pendingTx || __props.stagingTx) && !isExpired.value && !isInvalid.value && !isOnChain.value && doesNotExpire.value ? (openBlock(), createElementBlock("div", _hoisted_59, [
                    createBaseVNode("div", _hoisted_60, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.unlimited.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.unlimited.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : (__props.pendingTx || __props.stagingTx || __props.signed) && !isExpired.value && !isInvalid.value && !isOnChain.value && validFor.value ? (openBlock(), createElementBlock("div", _hoisted_61, [
                    createBaseVNode("div", _hoisted_62, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.validFor.label") + ": " + validFor.value) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.validFor.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : (__props.pendingTx || __props.stagingTx) && isExpired.value && !isInvalid.value && !isOnChain.value ? (openBlock(), createElementBlock("div", _hoisted_63, [
                    createBaseVNode("div", _hoisted_64, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.expired.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.expired.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true),
                  (__props.pendingTx || __props.stagingTx) && (isExpired.value || isInvalid.value || isSigned.value && !isSubmitted.value) ? (openBlock(), createElementBlock("div", _hoisted_65, [
                    createBaseVNode("div", {
                      class: "cc-btn-secondary-inline text-sm cc-text-semi-bold cursor-pointer px-4 ml-1",
                      onClick: withModifiers(onRemoveExpiredTx, ["stop"])
                    }, [
                      createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.remove.label")) + " ", 1),
                      createVNode(_sfc_main$h, {
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.transactions.badge.remove.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true)
                ])
              ]),
              !__props.stagingTx && !__props.pendingTx && !__props.signed ? (openBlock(), createElementBlock("div", _hoisted_66, toDisplayString(unref(formatDatetime)(blockTime.value)), 1)) : __props.pendingTx && __props.tx ? (openBlock(), createElementBlock("div", _hoisted_67, toDisplayString(unref(formatDatetime)(__props.tx.time)), 1)) : (openBlock(), createElementBlock("div", _hoisted_68, "Valid until: " + toDisplayString(unref(formatDatetime)(new Date(unref(now)() + 3600 * 1e3 * 3))), 1)),
              isCommentsEnc.value || numComments.value > 0 ? (openBlock(), createBlock(GridSpace, { key: 3 })) : createCommentVNode("", true),
              numComments.value > 0 || isCommentsEnc.value ? (openBlock(), createElementBlock("div", {
                key: 4,
                class: normalizeClass(["relative group flex flex-row", isCommentsEnc.value ? "cursor-pointer" : ""]),
                onClick: withModifiers(onDecryptMsg, ["stop", "prevent"])
              }, [
                isCommentsEnc.value ? (openBlock(), createBlock(_sfc_main$h, {
                  key: 0,
                  anchor: "bottom middle",
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(numComments.value > 0 ? unref(t)("wallet.transactions.message.hover.unlocked") : unref(t)("wallet.transactions.message.hover.locked")), 1)
                  ]),
                  _: 1
                })) : createCommentVNode("", true),
                isCommentsEnc.value ? (openBlock(), createElementBlock("i", {
                  key: 1,
                  class: normalizeClass(["absolute text-md top-1/2 -translate-y-1/2 -left-2.5 mdi px-2 py-4", !isCommentsEnc.value ? "" : numComments.value > 0 ? "mdi-lock-open-variant-outline cc-text-green" : "mdi-key-outline cc-text-blue-light"])
                }, null, 2)) : createCommentVNode("", true),
                createBaseVNode("div", _hoisted_69, [
                  numComments.value === 0 ? (openBlock(), createElementBlock("div", _hoisted_70, toDisplayString(unref(t)("wallet.transactions.message.encrypted")), 1)) : (openBlock(), createElementBlock("div", _hoisted_71, [
                    (openBlock(true), createElementBlock(Fragment, null, renderList(commentsHeader.value, (msg, index) => {
                      return openBlock(), createElementBlock("div", {
                        class: "inline",
                        key: msg + index
                      }, toDisplayString(numComments.value > 1 ? index + ": " : "") + toDisplayString(msg), 1);
                    }), 128)),
                    hasMoreComments.value ? (openBlock(), createElementBlock("div", _hoisted_72, "...")) : createCommentVNode("", true)
                  ]))
                ])
              ], 2)) : createCommentVNode("", true)
            ]),
            unref(txBalance) ? (openBlock(), createBlock(_sfc_main$r, {
              key: 1,
              "tx-balance": unref(txBalance)
            }, null, 8, ["tx-balance"])) : createCommentVNode("", true)
          ], 2)) : createCommentVNode("", true),
          (open.value || __props.alwaysOpen || loaded.value) && unref(txBalance) ? withDirectives((openBlock(), createBlock(_sfc_main$1, {
            key: 1,
            "tx-balance": unref(txBalance),
            tx: __props.tx,
            "account-id": unref(accountId),
            msg: comments.value,
            isMsgEnc: isCommentsEnc.value,
            witnessCheck: __props.witnessCheck,
            "staging-tx": __props.stagingTx || __props.pendingTx || __props.signed,
            "tx-viewer": __props.txViewer,
            onLoaded: _cache[2] || (_cache[2] = ($event) => loaded.value = true)
          }, null, 8, ["tx-balance", "tx", "account-id", "msg", "isMsgEnc", "witnessCheck", "staging-tx", "tx-viewer"])), [
            [vShow, (open.value || __props.alwaysOpen) && unref(txBalance)]
          ]) : createCommentVNode("", true)
        ], 2)) : createCommentVNode("", true),
        !__props.stagingTx && !__props.isLastItem ? (openBlock(), createBlock(GridSpace, {
          key: 2,
          hr: ""
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  DEFAULT_MSG_PASSWORD as D,
  _sfc_main as _,
  encryptMessage as e,
  loadTxCborList as l
};
