import { z as ref, D as watch, ae as useSelectedAccount, fc as getStagingTxList, fd as getStagingTxConfigList, fe as getBuiltTxList, ff as getBuiltTxBalanceList, k as dispatchSignalSync, fg as doResetAllTx, f as computed, fh as getDonationAddress, K as networkId, aY as checkEpochParams, fi as doAddOutput, fj as doRemoveOutput, fk as doAddDonation, fl as doRemoveDonation, fm as doAddAuxData, d as defineComponent, a5 as toRefs, o as openBlock, a as createBlock, a7 as useQuasar, bI as onBeforeMount, C as onMounted, aW as addSignalListener, fn as onTxAuxUpdate, aG as onUnmounted, aX as removeSignalListener, c as createElementBlock, b as withModifiers, q as createVNode, u as unref, e as createBaseVNode, n as normalizeClass, j as createCommentVNode, h as withCtx, cb as QToggle_default, H as Fragment, cf as getRandomId, fo as checkTxMetadataFromStringArray, fp as getTxMetadataFromStringArray, fq as UnstoppableDomainsError, es as getRequestData, et as ApiRequestType, fr as isValidSendAddress, fs as callAPI, ft as setMilkomedaParameter, fu as getMilkomedaMetadata, fv as getAssetCDN, fw as getImageB64, fx as AdaHandleError, i as createTextVNode, t as toDisplayString, be as useWalletAccount, eI as getAddressCredentials, fy as getIAppAccountByCred, db as getIAppWallet, fz as getAccountName, fA as onAddressBookEntryDeleted, fB as onAddressBookEntryUpdated, V as nextTick, eA as Transition, fC as isValidAddress, fD as isScriptAddress, fE as getDefaultErrorMessage, fF as addressBook, fG as updateAddressBookEntry, aI as useGuard, T as createSlots, fH as createIBalance, cG as subtract, ar as appLanguageTag, fI as clearValueJSON, fJ as getNewBuildCounter, fK as resetBuiltTx, bm as dispatchSignal, fL as onTxBuiltReset, fM as dispatchSignalSyncTo, fN as doUpdateAccountBalances, fO as onTxBuilt, fP as onTxBuiltError, fQ as onTxSignReset, fR as onAccountSettingsUpdated, fS as onAccountBalancesUpdated, fT as onSelectedUtxoToggled, B as useFormatter, eK as addValueToValue, fU as updateBalanceTotal, c4 as isLessThanZero, c3 as isZero, fV as getMinUtxo, eW as compare, fW as replaceMultiAssetInValue, fX as convertIAssetSendableListToMultiAssetJSON, eo as sleepDefault, fY as hasNewerBuild, fZ as doJustBuildTxSend, f_ as ErrorBuildTx, f$ as convertMultiAssetJSONToIAssetSendableList, g0 as getStagingTx, g1 as getBuiltTx, g2 as isEqual, cJ as abs, g3 as getTxBuiltErrorMsg, g4 as splitLargeOutput, g5 as updateValueJSONIfNeeded, g6 as addOutputIndex, g7 as addToBalance, g8 as decreaseBalance, aA as renderSlot, aZ as ErrorSignTx, g9 as getHintUtxoList, ga as getTransactionFromCbor, gb as fillInputUtxoList, bg as getSignTxCredList, gc as calcAccountTxBalance, eL as createIUtxo, bl as useSignTx, ct as onErrorCaptured, gd as getTxImportErrorMsg, bx as onTxSignCancel, bw as onTxSignSubmit, F as withDirectives, ge as vModelText, dq as Buffer$1, gf as pow, gg as MetadataJsonSchema, gh as getMetadataType, eQ as createJsonFromCborJson, I as renderList, gi as createIMetadata, gj as getMetadataFromJSON, gk as cslToJson, b0 as safeFreeCSLObject, gl as isProduction, Q as QSpinnerDots_default, gm as hasSelectedUtxos, gn as doClearSelectedUtxos, aP as sleep, go as onBuiltTxTF, gp as doBuildTxTF, gq as doBuildTxCU, gr as parseTxSignRequest, gs as doBuildTxMSCU, w as watchEffect, gt as doJustSendBuiltTx } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$D } from "./AccountUtxoBalance.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$j } from "./GridButton.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$k, a as _sfc_main$l } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridInput } from "./GridInput.js";
import { I as IconPencil } from "./IconPencil.js";
import { _ as _sfc_main$m } from "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import { D as DEFAULT_MSG_PASSWORD, e as encryptMessage, _ as _sfc_main$B } from "./GridTxListBalance.vue_vue_type_script_setup_true_lang.js";
import { r as resolveAdaHandle, _ as _sfc_main$o, i as isAdaHandle, a as _sfc_main$v } from "./AddressBook.vue_vue_type_script_setup_true_lang.js";
import { i as isMilkomedaAddress, g as getMilkomedaData, n as networkMetadataUrl, a as networkMetadataUrlKey, b as networkMetadataAddressKey, S } from "./vue-json-pretty.js";
import { u as useBlacklist } from "./useBlacklist.js";
import { _ as _sfc_main$n } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { _ as _sfc_main$u } from "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$r } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$q } from "./ScanQrCode2.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$p } from "./SendWalletList.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$s } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$t } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { u as useAdaSymbol } from "./useAdaSymbol.js";
import { _ as _sfc_main$w } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$x } from "./GridTokenList.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$y } from "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$z } from "./ExternalLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$A } from "./GridAccountUtxoList.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$C } from "./GridButtonCountdown.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useNavigation.js";
import "./useTabId.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./IconError.js";
import "./GridTxListEntryBalance.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListUtxoListBadges.vue_vue_type_script_setup_true_lang.js";
import "./ReportLabelNewModal.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
import "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
import "./AccessPasswordInputModal.vue_vue_type_script_setup_true_lang.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./IconDelete.js";
import "./QrcodeStream.js";
import "./scanner.js";
import "./AccountItemBalance.vue_vue_type_script_setup_true_lang.js";
import "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import "./InlineButton.vue_vue_type_script_setup_true_lang.js";
import "./lz-string.js";
import "./image.js";
import "./ExtBackground.js";
import "./defaultLogo.js";
import "./GridAccountUtxoItem.vue_vue_type_script_setup_true_lang.js";
import "./IconButton.vue_vue_type_script_setup_true_lang.js";
const {
  hasSelectedAccount,
  hasSelectedWallet,
  selectedAccountId,
  selectedWalletId,
  appWallet,
  appAccount,
  walletData,
  walletSettings,
  accountData,
  accountSettings,
  accountBalances: appAccountBalances,
  utxoMap,
  setSelectedAccountId,
  setSelectedWalletId,
  isSelectedWallet
} = useSelectedAccount();
const stagingTxList = ref(null);
const stagingTxConfigList = ref(null);
const builtTxList = ref(null);
const builtTxBalanceList = ref(null);
const updateRefs = () => {
  if (appAccount.value) {
    stagingTxList.value = getStagingTxList(appAccount.value);
    stagingTxConfigList.value = getStagingTxConfigList(appAccount.value);
    builtTxList.value = getBuiltTxList(appAccount.value);
    builtTxBalanceList.value = getBuiltTxBalanceList(appAccount.value);
    resetAllTx();
  } else {
    stagingTxList.value = null;
  }
};
const addOutput = (txIndex, address = "", coin = "0", multiasset) => {
  if (appAccount.value) {
    dispatchSignalSync(doAddOutput, appAccount.value, txIndex, address, coin, multiasset);
  }
};
const removeOutput = (txIndex, outputIndex) => {
  if (appAccount.value) {
    dispatchSignalSync(doRemoveOutput, appAccount.value, txIndex, outputIndex);
  }
};
const addDonation = (txIndex) => {
  if (appAccount.value) {
    dispatchSignalSync(doAddDonation, appAccount.value, txIndex);
  }
};
const removeDonation = (txIndex) => {
  if (appAccount.value) {
    dispatchSignalSync(doRemoveDonation, appAccount.value, txIndex);
  }
};
const addAuxData = (txIndex, auxDataJSON, replace) => {
  if (appAccount.value) {
    dispatchSignalSync(doAddAuxData, appAccount.value, txIndex, auxDataJSON, replace);
  }
};
const resetAllTx = () => {
  if (appAccount.value) {
    dispatchSignalSync(doResetAllTx, appAccount.value);
  }
};
watch(appAccount, () => {
  updateRefs();
}, { immediate: true });
function useAppAccountTxLists(txIndex, outputIndex) {
  const stagingTx = computed(() => {
    if (!stagingTxList.value) {
      return null;
    }
    if (((txIndex == null ? void 0 : txIndex.value) ?? -1) < 0) {
      return null;
    }
    return stagingTxList.value[txIndex.value] ?? null;
  });
  const stagingTxConfig = computed(() => {
    if (!stagingTxConfigList.value) {
      return null;
    }
    if (((txIndex == null ? void 0 : txIndex.value) ?? -1) < 0) {
      return null;
    }
    return stagingTxConfigList.value[txIndex.value] ?? null;
  });
  const builtTx = computed(() => {
    if (!builtTxList.value) {
      return null;
    }
    if (((txIndex == null ? void 0 : txIndex.value) ?? -1) < 0) {
      return null;
    }
    return builtTxList.value[txIndex.value] ?? null;
  });
  const builtTxBalance = computed(() => {
    if (!builtTxBalanceList.value) {
      return null;
    }
    if (((txIndex == null ? void 0 : txIndex.value) ?? -1) < 0) {
      return null;
    }
    return builtTxBalanceList.value[txIndex.value] ?? null;
  });
  const output = computed(() => {
    var _a;
    const _outputIndex = (outputIndex == null ? void 0 : outputIndex.value) ?? -1;
    if (_outputIndex < 0) {
      return null;
    }
    const body = (_a = stagingTx.value) == null ? void 0 : _a.body;
    if (!body) {
      return null;
    }
    if (body.outputs.length <= _outputIndex) {
      return null;
    }
    return body.outputs[_outputIndex];
  });
  const hasDonation = computed(() => {
    if (stagingTx.value) {
      const donationAddr = getDonationAddress(networkId.value);
      for (const output2 of stagingTx.value.body.outputs) {
        if (output2.address === donationAddr) {
          return true;
        }
      }
    }
    return false;
  });
  const numOutputs = computed(() => {
    var _a;
    return ((_a = stagingTx.value) == null ? void 0 : _a.body.outputs.length) ?? 0;
  });
  const outputAddress = computed(() => {
    var _a;
    return ((_a = output.value) == null ? void 0 : _a.address) ?? null;
  });
  const auxData = computed(() => {
    var _a;
    return ((_a = stagingTx.value) == null ? void 0 : _a.auxiliary_data) ?? null;
  });
  const isLargeOutput = computed(() => {
    if (output.value) {
      const epochParams = checkEpochParams(networkId.value);
      if (epochParams && output.value.cborSize >= epochParams.maxValueSize - 100) {
        return true;
      }
    }
    return false;
  });
  const isDonation = computed(() => {
    var _a;
    const addr = outputAddress.value;
    const _networkId = (_a = accountData.value) == null ? void 0 : _a.state.networkId;
    if (!addr || !_networkId) {
      return false;
    }
    const donationAddr = getDonationAddress(_networkId);
    return addr === donationAddr;
  });
  return {
    stagingTxList,
    builtTxList,
    builtTxBalanceList,
    stagingTx,
    stagingTxConfig,
    output,
    numOutputs,
    builtTx,
    builtTxBalance,
    hasSelectedAccount,
    hasSelectedWallet,
    selectedAccountId,
    selectedWalletId,
    appWallet,
    appAccount,
    walletData,
    walletSettings,
    accountData,
    accountSettings,
    accountBalances: appAccountBalances,
    utxoMap,
    hasDonation,
    isDonation,
    outputAddress,
    auxData,
    isLargeOutput,
    setSelectedAccountId,
    setSelectedWalletId,
    isSelectedWallet,
    addOutput,
    removeOutput,
    addDonation,
    removeDonation,
    addAuxData,
    resetAllTx
  };
}
const _icon = "mdi mdi-heart-outline text-xl text-red-500";
const _iconChecked = "mdi mdi-heart         text-xl text-red-500";
const _sfc_main$i = /* @__PURE__ */ defineComponent({
  __name: "GridButtonDonation",
  props: {
    label: { type: String },
    caption: { type: String },
    icon: { type: String },
    iconClickable: { type: Boolean, default: false },
    type: { type: String, required: false, default: "button" },
    form: { type: String, required: false, default: "" },
    link: { type: Function, default: null },
    capitalize: { type: Boolean, default: true },
    disabled: { type: Boolean, default: false },
    disableTooltip: { type: String, required: false },
    hasDonation: { type: Boolean }
  },
  emits: ["checked"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const { hasDonation } = toRefs(props);
    const emit = __emit;
    const checked = ref(false);
    const iconCss = computed(() => checked.value ? _iconChecked : _icon);
    watch(() => hasDonation.value, (value) => {
      checked.value = value;
    });
    const onClicked = () => {
      checked.value = !checked.value;
      emit("checked", checked.value);
    };
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$j, {
        label: __props.label,
        caption: __props.caption,
        icon: iconCss.value,
        link: onClicked,
        type: __props.type,
        form: __props.form,
        disabled: __props.disabled,
        capitalize: __props.capitalize,
        disableTooltip: __props.disableTooltip,
        "icon-clickable": false,
        class: "py-2 text-center cc-text-md cc-text-semi-bold cc-btn-secondary"
      }, null, 8, ["label", "caption", "icon", "type", "form", "disabled", "capitalize", "disableTooltip"]);
    };
  }
});
const _hoisted_1$g = {
  key: 1,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_2$c = { class: "col-span-12 flex flex-row flex-nowrap cc-gap" };
const _sfc_main$h = /* @__PURE__ */ defineComponent({
  __name: "SendMetadataInput",
  props: {
    textId: { type: String, required: true, default: "wallet.send.step.metadata" },
    txIndex: { type: Number, required: true },
    rows: { type: Number, required: false, default: 2 },
    startExpanded: { type: Boolean, required: false, default: false },
    showOnlyInput: { type: Boolean, required: false, default: false }
  },
  emits: ["submit", "update", "encrypt"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const storeId = "SendMetadataInput" + getRandomId();
    const $q = useQuasar();
    const { it } = useTranslation();
    const { txIndex } = toRefs(props);
    const {
      appAccount: appAccount2,
      accountData: accountData2,
      stagingTx,
      stagingTxConfig,
      builtTx,
      builtTxBalance,
      output,
      addAuxData: addAuxData2
    } = useAppAccountTxLists(txIndex, ref(0));
    const showMessageInput = ref(props.startExpanded);
    const metaInput = ref("");
    const metaInputError = ref("");
    const doEncrypt = ref(false);
    const password = ref("");
    const resetCounter = ref(0);
    const setInitialValues = () => {
      var _a;
      if (stagingTxConfig.value) {
        metaInput.value = stagingTxConfig.value.metadata674Lines.join("\n");
        if (typeof ((_a = stagingTxConfig.value) == null ? void 0 : _a.metadataPassword) !== "string") {
          doEncrypt.value = false;
          password.value = "";
        } else {
          doEncrypt.value = true;
          const pw = stagingTxConfig.value.metadataPassword ?? "";
          if (pw === DEFAULT_MSG_PASSWORD) {
            password.value = "";
          } else {
            password.value = pw;
          }
        }
      }
      showMessageInput.value = props.startExpanded || metaInput.value.length > 0;
      validateMessageInput(metaInput.value, false);
    };
    onBeforeMount(() => {
      setInitialValues();
    });
    const onSubmitPassword = (value) => {
      password.value = value.password;
      validateMessageInput(metaInput.value);
    };
    const onUpdateToggle = (value) => {
      validateMessageInput(metaInput.value);
    };
    const validateMessageInput = async (value, updateMetadata = true) => {
      metaInputError.value = "";
      metaInput.value = value;
      let auxDataJSON = null;
      if (metaInput.value && metaInput.value.length > 0 && metaInput.value[0].length > 0) {
        try {
          let encryption = void 0;
          let messageLines = metaInput.value.split("\n");
          checkTxMetadataFromStringArray(messageLines);
          if (stagingTxConfig.value) {
            stagingTxConfig.value.metadata674Lines = messageLines;
          }
          if (doEncrypt.value) {
            let pw = password.value;
            if (pw.length === 0) {
              pw = DEFAULT_MSG_PASSWORD;
            }
            if (stagingTxConfig.value) {
              stagingTxConfig.value.metadataPassword = pw;
            }
            const encMetadata = await encryptMessage(metaInput.value, pw);
            messageLines = encMetadata.match(/.{1,64}/g) ?? [];
            encryption = "basic";
          } else {
            if (stagingTxConfig.value) {
              stagingTxConfig.value.metadataPassword = null;
            }
          }
          const meta = getTxMetadataFromStringArray(messageLines, 674, encryption);
          if (meta) {
            auxDataJSON = meta;
          }
        } catch (err) {
          metaInputError.value = err.message ?? err;
          console.error(metaInputError.value);
          $q.notify({
            type: "negative",
            message: it("wallet.send.builder.modal.metadata.builderror"),
            position: "top-left"
          });
        }
      }
      if (updateMetadata) {
        addAuxData2(txIndex.value, auxDataJSON, true);
      }
    };
    const toggleShowMessageInput = () => {
      showMessageInput.value = !showMessageInput.value;
    };
    const onReset = () => {
      metaInput.value = "";
      metaInputError.value = "";
      validateMessageInput(metaInput.value);
    };
    onMounted(() => addSignalListener(onTxAuxUpdate, storeId, setInitialValues));
    onUnmounted(() => removeSignalListener(onTxAuxUpdate, storeId));
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        !__props.showOnlyInput ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: "col-span-12 flex flex-row flex-nowrap items-center cursor-pointer",
          onClick: withModifiers(toggleShowMessageInput, ["stop"])
        }, [
          createVNode(_sfc_main$k, {
            label: unref(it)(__props.textId + ".label"),
            class: ""
          }, null, 8, ["label"]),
          createBaseVNode("i", {
            class: normalizeClass(["relative text-xl ml-1", showMessageInput.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
          }, null, 2)
        ])) : createCommentVNode("", true),
        showMessageInput.value ? (openBlock(), createElementBlock("div", _hoisted_1$g, [
          !__props.showOnlyInput ? (openBlock(), createBlock(_sfc_main$l, {
            key: 0,
            text: unref(it)(__props.textId + ".caption"),
            class: "col-span-12 cc-text-sz"
          }, null, 8, ["text"])) : createCommentVNode("", true),
          createVNode(GridInput, {
            "input-text": metaInput.value,
            "onUpdate:inputText": [
              _cache[0] || (_cache[0] = ($event) => metaInput.value = $event),
              _cache[2] || (_cache[2] = ($event) => validateMessageInput($event, true))
            ],
            "input-error": metaInputError.value,
            "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => metaInputError.value = $event),
            class: "col-span-12",
            "input-id": "inputMetadata",
            "input-type": "text",
            "always-show-info": false,
            rows: __props.rows,
            "input-hint": unref(it)(__props.textId + ".hint"),
            onReset,
            autofocus: "",
            autoIncreaseRows: "",
            "show-reset": "",
            "multiline-input": ""
          }, {
            "icon-prepend": withCtx(() => [
              createVNode(IconPencil, { class: "h-5 w-5" })
            ]),
            _: 1
          }, 8, ["input-text", "input-error", "rows", "input-hint"]),
          createBaseVNode("div", _hoisted_2$c, [
            createVNode(QToggle_default, {
              modelValue: doEncrypt.value,
              "onUpdate:modelValue": [
                _cache[3] || (_cache[3] = ($event) => doEncrypt.value = $event),
                onUpdateToggle
              ],
              label: "Encrypt",
              "left-label": ""
            }, null, 8, ["modelValue"]),
            doEncrypt.value ? (openBlock(), createBlock(_sfc_main$m, {
              key: 0,
              class: "grow",
              autocomplete: "off",
              "text-id": "form.password.general.encryptmsg",
              "pre-filled-password": password.value,
              "reset-counter": resetCounter.value,
              onOnSubmittable: onSubmitPassword,
              autofocus: "",
              "skip-validation": ""
            }, null, 8, ["pre-filled-password", "reset-counter"])) : createCommentVNode("", true)
          ])
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const resolving$1 = ref(false);
const useAdaHandle = () => {
  return { resolving: resolving$1 };
};
const isUnstoppableDomain = (value) => !!value && value.endsWith(".clay");
const resolveUnstoppableDomain = async (networkId2, accountId, domain) => {
  if (!isUnstoppableDomain(domain)) {
    throw UnstoppableDomainsError.invalidDomain;
  }
  try {
    const address = await getRequestData()(
      networkId2,
      accountId,
      ApiRequestType.resolveUnstoppableDomain,
      UnstoppableDomainsError.notResolved,
      {
        id: accountId,
        domain
      },
      async (data) => (data == null ? void 0 : data.address) ?? null
    );
    if (address === "noresult") {
      throw UnstoppableDomainsError.domainNotFound;
    } else if (address === "noaddress") {
      throw UnstoppableDomainsError.addressNotSet;
    } else if (!address || !isValidSendAddress(networkId2, address)) {
      throw UnstoppableDomainsError.invalidAddress;
    }
    return address;
  } catch (err) {
    if (typeof err === "string") {
      if (err.includes(":")) {
        const errorParts = err.split(":");
        throw errorParts[errorParts.length - 2];
      } else {
        throw err;
      }
    }
    throw (err == null ? void 0 : err.message) ?? JSON.stringify(err);
  }
};
const resolving = ref(false);
const unstoppabledomainsLogo = "data:image/webp;base64,UklGRqoHAABXRUJQVlA4IJ4HAACwNACdASoYARgBPpFGoEwlo6MiInC5CLASCWVu4XNA+dy/6rVWe8fbD0M3CfhHmiUk+qfvZ/R6VX6H9gD9Iv9P+r3ZY8wH7S+sN/ef1N9yn+39QD/M/4DrSPQA/bv06vZE/cb9yPZz//+sheL/8H2xf5/z/fE75e0b/kt4IInyO1SHcA+qEdmRZDwaieeMWWF7gvcF7gvcF7gvcF7gvcF7gvcF7SYfSpBUBoHTLVmRZDwaLkNVHOmbsmkg6fOptjMxK2ZFkPBowezNjEHSOpL1RPO/Cpt+9kM8NqyqLsmmHpTz7fqtwh7jQm+fqdMvLE9B92NbJHEe/8uRalMHjEenk6QBuksETv7nRdgsJfmOWMVtY1+ciTuTdtEEXkXrUkm+jnqMYssKiLaALQAmtANjOTTEDZSvGjVPbS9aidw5/bSRpeC1AmWWB4m6j91FlVy7Io7pEUlnD7vxk351aMFyMi6QeR00Cvf68FeLb0j6aieeMyfS7WnouJAw/pGA+PEZqbgfdI5+h4NRPPQm/g1n/AeDUTzxiywvcF7gvcF7gvcF7gvcF7gvcF7gvaAAAP79jk/+tyf83J/zcjO1lzLh7rVryX6MmqEKIhhIBBXgAFQ7k6IOmWCMZb0uFj6tlV07B/jpO+xyjM6FHpW2anZPnF8PXOHM2/HleXJRmXZSByE+l0ee4ZI0jr+eG+DoxlTTvVgYfhHqO9u75pi7DOx7q/Uyq6P90gFo2Om75f0oP9gLRxY4xal3yyUG/L6AVERAg/+Gf1FHb4ZeXw3ZNTlbL1B6Nd0D6cKmJGIeUdYFU5Qznd1OjZkT4/XFoqxdoXD6FKb2muJmUyk37baAHCAMdVW1Uy+Tdkb6GWE+Oblm+uIdDzRmCs/OS3pYTnxfezoJGrqVMTyClwANjRt82ReRCmrNjAmhAqXSW//BCvXb+3hwkhCsVBthyLqY1C5BqNP5ohenDTCi+tCySJG/9G3yUD5+h8vXca1oem2BuatItGsJhMHGTcJMUVbVmIPC+f89Vzp8DUtP3KRclqHCXuc9krh09EWBve/EIKL8oik98qO/FGc3fFtM82Amci3ugYh3ZI3JFIJEt7X1ib9u1oyHwOYbVPZ1TQM68B5IUrYJ1RW/X0t5oXVecSIn99M6OASi2gsseztr+HVhc53TnVPCEbAeL2ukaWvR46G2SbgCHtTqGyP+8/x1R7c4U7Ndaf6mP+iqB5fJEPaCkqDtLok81NhSrRPVKbnQ8h55uOIlfz9LNamaDZAztZrai5knt11XBRirb2xI+3O6T8BibcCocqGV0pp8Kcqt9+g/BQVbvlflIVxWkkTJZnkzv3JCNTSXohG+6OdVYOLa3iMeFXfNMyxnPxeOczatK6MVviBg0/C6Kb5eKEbWdKJtwQrlWcBYFw/gNhF2Z8rW9SBqU04NHxz1XlCPboUlFBqC3M4xz41tb6uem/Rg6iknveKUC0RMiL/C67GbKaGhibIHBv++Iw5+80EaUmZhr8HKpkOZfqHG15P3B3uy2AxdJ3XT76vo1mlqcVp6+tVYVSCrA7MJDGga+CULYYdRohvDIlwkJo4lsi1mGvd18U81dxtFlNk2Z/KDDczGcDKCOSfVFxYw4WmQTlgCDZdrnrEBZgE0YhG2PygEpvLnkXuuXafvl/uUmdGopBRxA15qHq4S077MZeOqHrkYv8ME5OLtehyorXRxHUif//b7a/ItW+M3zwFiK568fF85K9i5FndxGxvulSss17QgUouZdt2lG6l6KsiSYv4/y8YsCxCL2kyXpcF38S5UYApoJNuqzDRiZrnoszKrn0rH7l0IXvSAU5SrOAsC4fw30I4R0mMuv159HMjTRsDSe92FPwuim+XihG1nSC4w8efyiW9Dgalsr+c/z5rxyoYkY3Jh5MrBskjhjG8/VnVPAGNqPYxvEapYguuwgXasYkBInEQoz7/hGc3O+6ET1yoNF2Q4hNmv5lP2VX9GT9PRttSVDrrtvDF6ku/lTJrdEwwCcrk/vi/WVkKWp24J4/7D6klc+/wkjsHEF+ap7ypvT4Q0zFYvc0LAKYrsZCL3GcIGK9QJEX0xe5DBjx/6XZNd9cxuaJyNys87WqMcl5xeG5++GRB0avwcaVJnhqa419bRlQy4bJ67Tum5dIAtKDOMWrALLy+Z6vKpciIRaKqh3PSjcpyKvFHzPwTgDXoab6DJ1lVmEVe6O0RxYuOlZu+qfh+f0jafWBTz431R0AP3jW1k/mKosAHPEnGlfGr9LC6rZv/nQ0zNn7mjwQBRpu3DbIwJqAnQ52H01CKol9lmOeJrP9MJo9dX6RQU4qi/U2zLFJjfSBQAFVaRDmevl+PVa3yOEAXJ8Fg1fAl8Ah6fX4J9mHXj/ou8SUdjOXO7rAA/6SIwx/my5h9cHSuHLpeOl5l8b4U3bExyH76pIe+TvFIViO/ksOnlTtzjHwT/cSo6zHi9ZPsp8Im5XR2st56kXuw4JPGJMwTt7d/Ply4BA+STzkCahKwMMf5Yoql05Nk6McbucqwIULhZ27lyb4HJqAFbyCh0riUnnyJk2+bh1FPFBnah4nlHyTAQSrL8oAAAAAAAAAAAAAA=";
const useUnstoppableDomains = () => {
  return { resolving, unstoppabledomainsLogo };
};
const _entryInAddressBook = ref(null);
const milkomedaAddr = ref("");
const milkomedaBridgeAddr = ref("");
const milkomedaBridgeAddrValid = ref(false);
const milkomedaAddrAppend = ref("");
const milkomedaFeeAppend = ref("");
const milkomedaFee = ref(0);
const milkomedaMinLovelace = ref(0);
const milkomedaAuxData = ref(null);
const isMilkomedaTx = ref(false);
const hasMilkomedaData = ref(false);
const getMilkomedaAuxData = (address) => {
  const url = networkMetadataUrl[networkId.value];
  if (url) {
    return getMilkomedaMetadata([networkMetadataUrlKey, networkMetadataAddressKey], [url, address]);
  }
  return null;
};
const reset = () => {
  hasMilkomedaData.value = false;
  isMilkomedaTx.value = false;
  milkomedaBridgeAddrValid.value = false;
  milkomedaFee.value = 0;
  milkomedaMinLovelace.value = 0;
  milkomedaBridgeAddr.value = "";
  milkomedaAddrAppend.value = "";
  milkomedaFeeAppend.value = "";
  milkomedaAddr.value = "";
  milkomedaAuxData.value = null;
};
const onLoadList = (milkomedaData, address) => {
  hasMilkomedaData.value = true;
  milkomedaBridgeAddrValid.value = isValidSendAddress(networkId.value, milkomedaData.current_address);
  milkomedaFee.value = milkomedaData.ada.fromADAFeeLovelace;
  milkomedaMinLovelace.value = milkomedaData.ada.minLovelace;
  milkomedaBridgeAddr.value = milkomedaData.current_address;
  milkomedaAddrAppend.value = "<span><b>Milkomeda (Beware: this is <u>NOT</u> an Ethereum or BSC address!):</b><br>" + address + "</span><span><b>Bridge Address:</b></span>";
  milkomedaFeeAppend.value = "<span><b>Milkomeda C1 min ADA to sent / C1 transaction fee:</b><br>" + (milkomedaMinLovelace.value ?? 0) / 1e6 + ".0 / " + (milkomedaFee.value ?? 0) / 1e6 + " mADA</span>";
  milkomedaAddr.value = address;
  milkomedaAuxData.value = getMilkomedaAuxData(address);
  isMilkomedaTx.value = true;
};
const onErrorList = () => {
  reset();
  return;
};
const setMilkomedaAddress = async (address) => {
  const isMilkomedaAddr = isMilkomedaAddress(address) || !!_entryInAddressBook.value && isMilkomedaAddress(_entryInAddressBook.value.address ?? "");
  if (!isMilkomedaAddr) {
    reset();
    return;
  }
  const data = await getMilkomedaData(networkId.value);
  if (data) {
    onLoadList(data.config, address);
  } else {
    await callAPI("/v2/misc/milkomeda", networkId.value, (response) => {
      if (!response || response.status !== 200) {
        onErrorList();
        return;
      }
      const milkomedaData = response.data.config;
      if (!milkomedaData) {
        onErrorList();
        return;
      }
      setMilkomedaParameter(networkId.value, {
        config: milkomedaData,
        lastSyncTimestamp: Date.now()
      });
      onLoadList(milkomedaData, address);
    }, onErrorList);
  }
};
function useMilkomeda(entryInAddressBook) {
  watch(entryInAddressBook, (value) => {
    _entryInAddressBook.value = value;
  }, { immediate: true, deep: true });
  return {
    milkomedaAddr,
    milkomedaAuxData,
    milkomedaBridgeAddr,
    milkomedaBridgeAddrValid,
    milkomedaAddrAppend,
    milkomedaFeeAppend,
    milkomedaFee,
    milkomedaMinLovelace,
    isMilkomedaTx,
    hasMilkomedaData,
    setMilkomedaAddress
  };
}
const _sfc_main$g = {};
const _hoisted_1$f = {
  xmlns: "http://www.w3.org/2000/svg",
  stroke: "none",
  viewBox: "0 0 24 24",
  fill: "currentColor",
  "aria-hidden": "true"
};
function _sfc_render(_ctx, _cache) {
  return openBlock(), createElementBlock("svg", _hoisted_1$f, _cache[0] || (_cache[0] = [
    createBaseVNode("path", { d: "M17,4V10L15,8L13,10V4H9V20H19V4H17M3,7V5H5V4C5,2.89 5.9,2 7,2H19C20.05,2 21,2.95 21,4V20C21,21.05 20.05,22 19,22H7C5.95,22 5,21.05 5,20V19H3V17H5V13H3V11H5V7H3M5,5V7H7V5H5M5,19H7V17H5V19M5,13H7V11H5V13Z" }, null, -1)
  ]));
}
const IconBook = /* @__PURE__ */ _export_sfc(_sfc_main$g, [["render", _sfc_render]]);
const _hoisted_1$e = ["src"];
const _sfc_main$f = /* @__PURE__ */ defineComponent({
  __name: "ResolveHandle2",
  props: {
    showAddress: { type: Boolean, required: false, default: true }
  },
  emits: ["resolved", "error"],
  setup(__props, { expose: __expose, emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const { resolving: resolving2 } = useAdaHandle();
    const showHandleImage = ref(false);
    const scaleImage = ref(false);
    const adaHandle = ref("");
    const handleImageBase64 = ref("");
    const resolvedAddress = ref("");
    const doResolve = async (_adaHandle) => {
      console.warn("doResolve", _adaHandle);
      adaHandle.value = _adaHandle;
      resolving2.value = true;
      try {
        const handle = await resolveAdaHandle(networkId.value, _adaHandle);
        resolvedAddress.value = handle.address;
        const assetCDN = await getAssetCDN(handle.fingerprint);
        showHandleImage.value = false;
        if (!assetCDN) {
          onError(it("wallet.settings.changeaddr.error"), false);
          emit("resolved", handle.address);
        } else if (assetCDN.i) {
          handleImageBase64.value = getImageB64(assetCDN.i);
          showHandleImage.value = true;
          emit("resolved", handle.address);
        }
      } catch (err) {
        console.error(err);
        if (err === AdaHandleError.invalidAddress) {
          onError(AdaHandleError.invalidAddress);
        } else if (err === AdaHandleError.invalidAdaHandle) {
          onError(AdaHandleError.invalidAdaHandle);
        } else if (err === AdaHandleError.adaHandleNotResolved) {
          onError(AdaHandleError.adaHandleNotResolved);
        } else {
          console.error(err);
          onError(err);
        }
      }
      resolving2.value = false;
    };
    const onError = (error, blocking = true) => {
      emit("error", error, blocking);
    };
    const reset2 = () => {
      showHandleImage.value = false;
    };
    const onScaleImage = () => {
      scaleImage.value = true;
      setTimeout(() => {
        scaleImage.value = false;
      }, 3e3);
    };
    __expose({ reset: reset2, doResolve, resolving: resolving2 });
    return (_ctx, _cache) => {
      return handleImageBase64.value && showHandleImage.value ? (openBlock(), createElementBlock("img", {
        key: 0,
        src: handleImageBase64.value,
        class: normalizeClass([
          " rounded z-10 cursor-zoom-in",
          "transition-transform duration-500 origin-top-left xxxs:origin-top-right",
          scaleImage.value ? "scale-200" : ""
        ]),
        alt: "Resolved ADA Handle image.",
        onClick: withModifiers(onScaleImage, ["prevent", "stop"])
      }, null, 10, _hoisted_1$e)) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$d = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$b = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$a = { class: "p-1" };
const _sfc_main$e = /* @__PURE__ */ defineComponent({
  __name: "OpenAddressBookButton",
  props: {
    textId: { type: String, required: true, default: "wallet.send.step.receiveAddr" }
  },
  emits: ["select"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const showModal = ref(false);
    const onReset = () => {
      showModal.value = false;
    };
    const onOpen = () => {
      showModal.value = true;
    };
    const onSelectAddress = (address) => {
      if (address) {
        emit("select", address);
      }
      onReset();
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        class: "relative min-w-0 w-9 h-9 inline-flex flex-row flex-nowrap justify-center items-center cursor-pointer focus:outline-none text-sm cc-text-bold cc-btn-secondary",
        onClick: withModifiers(onOpen, ["stop", "prevent"])
      }, [
        createVNode(IconBook, { class: "h-5 w-5 mr-0.5" }),
        createVNode(_sfc_main$n, {
          anchor: "top middle",
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => [
            createTextVNode(toDisplayString(unref(it)(__props.textId + ".addrBook.show")), 1)
          ]),
          _: 1
        }),
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          onClose: onReset,
          narrow: "",
          "full-width-on-mobile": ""
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$d, [
              createBaseVNode("div", _hoisted_2$b, [
                createVNode(_sfc_main$k, {
                  label: unref(it)("common.label.addrbook")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$l, {
                  text: unref(it)(__props.textId + ".addrBook.caption")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_3$a, [
              createVNode(_sfc_main$o, {
                "full-width": "",
                combined: "",
                label: "",
                onSubmit: onSelectAddress
              })
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$c = {
  xmlns: "http://www.w3.org/2000/svg",
  stroke: "none",
  viewBox: "0 0 24 24",
  fill: "currentColor",
  "aria-hidden": "true"
};
const _hoisted_2$a = {
  key: 0,
  d: "M17,3H7A2,2 0 0,0 5,5V21L12,18L19,21V5C19,3.89 18.1,3 17,3Z"
};
const _hoisted_3$9 = {
  key: 1,
  d: "M17,18L12,15.82L7,18V5H17M17,3H7A2,2 0 0,0 5,5V21L12,18L19,21V5C19,3.89 18.1,3 17,3Z"
};
const _hoisted_4$7 = {
  key: 2,
  d: "M17,18V5H7V18L12,15.82L17,18M17,3A2,2 0 0,1 19,5V21L12,18L5,21V5C5,3.89 5.9,3 7,3H17M11,7H13V9H15V11H13V13H11V11H9V9H11V7Z"
};
const _sfc_main$d = /* @__PURE__ */ defineComponent({
  __name: "IconBookmark",
  props: {
    filled: { type: Boolean, required: false, default: false },
    add: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("svg", _hoisted_1$c, [
        !__props.add && __props.filled ? (openBlock(), createElementBlock("path", _hoisted_2$a)) : createCommentVNode("", true),
        !__props.add ? (openBlock(), createElementBlock("path", _hoisted_3$9)) : createCommentVNode("", true),
        __props.add ? (openBlock(), createElementBlock("path", _hoisted_4$7)) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$b = { class: "relative min-w-0 w-9 h-9 inline-flex flex-row flex-nowrap justify-center items-center cursor-pointer focus:outline-none text-sm cc-text-bold cc-btn-secondary" };
const _sfc_main$c = /* @__PURE__ */ defineComponent({
  __name: "AddToAddressBookButton",
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", _hoisted_1$b, [
        createVNode(_sfc_main$d, { class: "h-5 w-5 -ml-px" }),
        createVNode(_sfc_main$n, {
          anchor: "top middle",
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => _cache[0] || (_cache[0] = [
            createTextVNode(" Add to Address Book ")
          ])),
          _: 1
        })
      ]);
    };
  }
});
const _hoisted_1$a = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$9 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$8 = { class: "p-1" };
const _sfc_main$b = /* @__PURE__ */ defineComponent({
  __name: "SelectAccountButton",
  props: {
    textId: { type: String, required: true, default: "wallet.send.step.receiveAddr" }
  },
  emits: ["select"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const showModal = ref(false);
    const onReset = () => {
      showModal.value = false;
    };
    const onOpen = () => {
      showModal.value = true;
    };
    const onSendToAccount = (info) => {
      var _a;
      const { accountSettings: accountSettings2 } = useWalletAccount(ref(info.walletId), ref(info.accountId));
      const addrBech32 = (_a = accountSettings2.changeAddress.value) == null ? void 0 : _a.addr.bech32;
      if (addrBech32) {
        emit("select", addrBech32);
      }
      onReset();
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        class: "relative min-w-0 h-7 sm:h-9 px-2.5 inline-flex flex-row flex-nowrap justify-center items-center cursor-pointer focus:outline-none text-sm cc-text-bold cc-btn-secondary",
        onClick: withModifiers(onOpen, ["stop", "prevent"])
      }, [
        _cache[1] || (_cache[1] = createBaseVNode("span", { class: "whitespace-nowrap cc-text-xs" }, "Select Account", -1)),
        createVNode(_sfc_main$n, {
          anchor: "top middle",
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => _cache[0] || (_cache[0] = [
            createTextVNode(" Select an account of one of your wallets. ")
          ])),
          _: 1
        }),
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          onClose: onReset,
          "full-width-on-mobile": ""
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$a, [
              createBaseVNode("div", _hoisted_2$9, [
                createVNode(_sfc_main$k, {
                  label: unref(it)("common.label.addrbook")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$l, {
                  text: unref(it)(__props.textId + ".addrBook.caption")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_3$8, [
              createVNode(_sfc_main$p, { onOnSendToAccount: onSendToAccount })
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$9 = {
  key: 0,
  class: "relative col-span-12 flex flex-col w-full"
};
const _hoisted_2$8 = { class: "flex sm:flex-row sm:flex-nowrap justify-between items-start sm:items-end" };
const _hoisted_3$7 = { class: "inline-flex flex-wrap justify-start cmr" };
const _hoisted_4$6 = {
  key: 0,
  class: "relative sm:min-w-[2.25rem] w-auto px-2 sm:px-2.5 py-1 cc-text-bold cc-text-sx cc-area-light inline-flex flex-row flex-nowrap justify-center items-center"
};
const _hoisted_5$3 = { key: 0 };
const _hoisted_6$2 = {
  key: 1,
  class: "mt-px"
};
const _hoisted_7 = {
  key: 2,
  class: "ml-1.5"
};
const _hoisted_8 = { key: 3 };
const _hoisted_9 = {
  key: 1,
  class: "relative w-7 sm:min-w-[2.25rem] w-auto px-2 sm:px-2.5 py-1 cc-text-bold cc-text-sx cc-area-light inline-flex flex-row flex-nowrap justify-center items-center"
};
const _hoisted_10 = { class: "cc-text-bold cc-text-sx ml-px" };
const _hoisted_11 = {
  key: 0,
  class: "absolute -top-1.5 -right-1 rounded-full bg-red-500 dark:bg-red-600 w-4 h-4 flex justify-center items-center"
};
const _hoisted_12 = {
  key: 1,
  class: "absolute -top-1.5 -right-1 rounded-full bg-yellow-500 dark:bg-yellow-600 w-4 h-4"
};
const _hoisted_13 = {
  key: 2,
  class: "absolute -top-1.5 -right-1 rounded-full bg-red-500 dark:bg-red-600 w-4 h-4"
};
const _hoisted_14 = {
  key: 3,
  class: "absolute -top-1.5 -right-1 rounded-full bg-green-500 dark:bg-green-600 w-4 h-4 flex justify-center items-center"
};
const _hoisted_15 = { class: "cc-text-bold cc-text-sx ml-px" };
const _hoisted_16 = {
  key: 0,
  class: "absolute -top-1.5 -right-1 rounded-full bg-red-500 dark:bg-red-600 w-4 h-4 flex justify-center items-center"
};
const _hoisted_17 = {
  key: 1,
  class: "absolute -top-1.5 -right-1 rounded-full bg-yellow-500 dark:bg-yellow-600 w-4 h-4"
};
const _hoisted_18 = {
  key: 2,
  class: "absolute -top-1.5 -right-1 rounded-full bg-red-500 dark:bg-red-600 w-4 h-4"
};
const _hoisted_19 = {
  key: 3,
  class: "absolute -top-1.5 -right-1 rounded-full bg-green-500 dark:bg-green-600 w-4 h-4 flex justify-center items-center"
};
const _hoisted_20 = ["disabled"];
const _hoisted_21 = ["disabled"];
const _hoisted_22 = {
  key: 6,
  class: "px-1.5 sm:px-2.5 py-1 max-w-[15rem] flex flex-nowrap justify-center items-center space-x-1 cc-text-medium rounded bg-gray-200 text-gray-800 dark:bg-gray-600 dark:text-gray-200"
};
const _hoisted_23 = { class: "cc-text-bold cc-text-sx" };
const _hoisted_24 = {
  key: 7,
  class: "h-12 px-1.5 sm:px-2.5 py-1 max-w-[15rem] flex flex-nowrap justify-center items-center space-x-1 cc-text-medium rounded cc-badge-bg-blue"
};
const _hoisted_25 = { class: "cc-text-bold cc-text-sx" };
const _hoisted_26 = {
  key: 8,
  class: "h-12 px-1.5 sm:px-2.5 py-1 max-w-[15rem] flex flex-nowrap justify-center items-center space-x-1 cc-text-medium rounded cc-badge-bg-blue"
};
const _hoisted_27 = {
  key: 9,
  class: "h-12 px-1.5 sm:px-2.5 py-1 max-w-[15rem] flex flex-nowrap justify-center items-center space-x-1 cc-text-medium rounded cc-badge-bg-blue"
};
const _hoisted_28 = { class: "cc-text-bold cc-text-sx" };
const _hoisted_29 = {
  key: 10,
  class: "h-12 px-1.5 sm:px-2.5 py-1 max-w-[15rem] flex flex-nowrap justify-center items-center space-x-1 cc-text-medium rounded cc-badge-bg-gray"
};
const _hoisted_30 = { class: "cc-text-bold cc-text-sx" };
const _hoisted_31 = {
  key: 11,
  class: "h-12 px-1.5 sm:px-2.5 py-1 max-w-[15rem] flex flex-nowrap justify-center items-center space-x-1 cc-text-medium rounded cc-badge-bg-purple"
};
const _hoisted_32 = { class: "inline-flex flex-row flex-nowrap justify-end cml" };
const _hoisted_33 = { class: "relative grow min-w-0 flex flex-row flex-nowrap justify-start items-start space-x-1 sm:space-x-2" };
const _hoisted_34 = { class: "relative flex-1 flex flex-col flex-nowrap justify-start items-start space-y-1 sm:space-y-2" };
const _hoisted_35 = { class: "relative w-full flex flex-col sm:flex flex-nowrap justify-start items-start" };
const _hoisted_36 = {
  class: "w-full grow flex flex-col xxxs:flex-row flex-nowrap",
  tabindex: "0"
};
const _hoisted_37 = ["src"];
const _hoisted_38 = {
  key: 0,
  class: "relative grow min-w-0 flex flex-col flex-nowrap justify-start items-start mt-2 hazard-border"
};
const _hoisted_39 = { class: "col-span-full grid cc-bg-white-0 p-2 rounded-borders" };
const _hoisted_40 = { class: "col-span-12 flex flex-row flex-nowrap justify-center items-center whitespace-pre-wrap cc-text-bold cc-text-red-light" };
const _hoisted_41 = { class: "col-span-full mt-2 w-full max-w-full mb-2 cc-test" };
const _hoisted_42 = ["innerHTML"];
const _hoisted_43 = ["innerHTML"];
const _hoisted_44 = {
  key: 2,
  class: "relative grow min-w-0 flex flex-row flex-nowrap justify-start items-start"
};
const _hoisted_45 = ["innerHTML"];
const _hoisted_46 = {
  key: 4,
  class: "relative grow min-w-0 flex flex-row flex-nowrap justify-start items-start"
};
const _hoisted_47 = { class: "p-4" };
const _hoisted_48 = { class: "grid grid-cols-12 cc-gap mt-2" };
const _sfc_main$a = /* @__PURE__ */ defineComponent({
  __name: "SendOutputAddress",
  props: {
    textId: { type: String, required: true, default: "wallet.send.step.receiveAddr" },
    txIndex: { type: Number, required: true },
    outputIndex: { type: Number, required: true },
    disabled: { type: Boolean, required: false, default: false },
    txBuilder: { type: Boolean, required: false, default: false },
    canBeEmpty: { type: Boolean, required: false, default: false },
    allowStakeAddresses: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const storeId = "SendOutputAddress" + getRandomId();
    const {
      txIndex,
      outputIndex
    } = toRefs(props);
    const $q = useQuasar();
    const { it } = useTranslation();
    const {
      selectedAccountId: selectedAccountId2,
      selectedWalletId: selectedWalletId2,
      accountData: accountData2,
      stagingTx,
      output,
      removeOutput: removeOutput2,
      addAuxData: addAuxData2
    } = useAppAccountTxLists(txIndex, outputIndex);
    const numOutputs = computed(() => {
      var _a;
      return ((_a = stagingTx.value) == null ? void 0 : _a.body.outputs.length) ?? 0;
    });
    const outputAddress = computed(() => {
      var _a;
      return ((_a = output.value) == null ? void 0 : _a.address) ?? "";
    });
    const isDonation = computed(() => {
      var _a;
      const addr = outputAddress.value;
      const _networkId = (_a = accountData2.value) == null ? void 0 : _a.state.networkId;
      if (!addr || !_networkId) {
        return false;
      }
      const donationAddr = getDonationAddress(_networkId);
      return addr === donationAddr;
    });
    const addressAppAccount = computed(() => {
      const addr = outputAddress.value;
      if (!addr) {
        return null;
      }
      const { paymentCred } = getAddressCredentials(addr);
      if (!paymentCred) {
        return null;
      }
      return getIAppAccountByCred(paymentCred, true);
    });
    const isSameAccount = computed(() => {
      const account = addressAppAccount.value;
      if (!account) {
        return false;
      }
      return account.id === selectedAccountId2.value;
    });
    const isSameWallet = computed(() => {
      const account = addressAppAccount.value;
      if (!account) {
        return false;
      }
      return account.walletId === selectedWalletId2.value;
    });
    const appWalletAddr = computed(() => {
      var _a;
      return getIAppWallet((_a = addressAppAccount.value) == null ? void 0 : _a.walletId);
    });
    const walletName = computed(() => {
      var _a;
      return ((_a = appWalletAddr.value) == null ? void 0 : _a.data.settings.name) ?? "";
    });
    const appAccountName = computed(() => {
      var _a;
      return getAccountName((_a = addressAppAccount.value) == null ? void 0 : _a.data).value;
    });
    const onRemoveOutput = () => removeOutput2(txIndex.value, outputIndex.value);
    const { scammerList } = useBlacklist();
    let timeoutId = -1;
    const addrInput = ref("");
    const addrInputError = ref("");
    const addrInputAppend = ref("");
    const addrAddressBook = ref("");
    const isScriptAddr = ref(false);
    const showScriptAddrModal = ref(false);
    const showScammerWarning = ref(false);
    const showAddBookmarkModal = ref({ display: false });
    const { resolving: resolvingAH } = useAdaHandle();
    const adaHandleResolve = ref(null);
    const adaHandle = ref("");
    const adaHandleAddress = ref("");
    const adaHandleAddressNew = ref("");
    const showAdaHandleResolve = ref(false);
    const adaHandleResolving = computed(() => resolvingAH.value);
    const {
      resolving: resolvingUD,
      unstoppabledomainsLogo: unstoppabledomainsLogo2
    } = useUnstoppableDomains();
    const unstoppabledomain = ref("");
    const unstoppabledomainAddress = ref("");
    const unstoppabledomainAddressNew = ref("");
    const unstoppabledomainShowResolve = ref(false);
    const unstoppabledomainResolving = computed(() => resolvingUD.value);
    const isValidReceiveAddr = ref(props.canBeEmpty);
    const entryInAddressBook = ref(null);
    const {
      milkomedaAddr: milkomedaAddr2,
      milkomedaBridgeAddr: milkomedaBridgeAddr2,
      isMilkomedaTx: isMilkomedaTx2,
      milkomedaAuxData: milkomedaAuxData2,
      milkomedaBridgeAddrValid: milkomedaBridgeAddrValid2,
      milkomedaAddrAppend: milkomedaAddrAppend2,
      milkomedaFeeAppend: milkomedaFeeAppend2,
      setMilkomedaAddress: setMilkomedaAddress2
    } = useMilkomeda(entryInAddressBook);
    const { isAddressOnBlockList } = useGuard();
    const textAreaField = ref(null);
    const onAddrInputUpdate = async (value) => {
      clearTimeout(timeoutId);
      if (adaHandleAddress.value.length > 0 && value === adaHandleAddress.value || unstoppabledomainAddress.value.length > 0 && value === unstoppabledomainAddress.value) {
        addrInputAppend.value = "";
      } else if (checkAdaHandle(addrInput.value)) {
        addrInputError.value = "";
        addrInputAppend.value = "ADA Handle (" + addrInput.value + "): not resolved yet.";
        return;
      } else if (checkUnstoppableDomain(addrInput.value)) {
        addrInputError.value = "";
        addrInputAppend.value = "Unstoppable Domain (" + addrInput.value + "): not resolved yet.";
        return;
      } else {
        entryInAddressBook.value = null;
      }
      await validateAddrInput();
      validateAddr();
    };
    const onResetAddrInputError = () => {
      addrInputError.value = "";
      addrInputAppend.value = "";
      isValidReceiveAddr.value = props.canBeEmpty;
    };
    const validateAddrInput = async () => {
      var _a, _b;
      await setMilkomedaAddress2("");
      showScammerWarning.value = false;
      if (!addrInput.value || addrInput.value.length === 0) {
        onResetAddrInputError();
        return;
      }
      if (!accountData2.value) {
        addrInputError.value = it("wallet.send.error.account");
        return;
      }
      let address = addrInput.value;
      if (scammerList.value.includes(address) || await isAddressOnBlockList(address)) {
        showScammerWarning.value = true;
        onResetAddrInputError();
        return;
      } else {
        showScammerWarning.value = false;
      }
      await setMilkomedaAddress2(address);
      checkBookmarked();
      if (props.allowStakeAddresses) {
        if (!isValidAddress(networkId.value, address)) {
          addrInputError.value = it(props.textId + ".error");
        } else {
          onResetAddrInputError();
        }
      } else {
        if (isMilkomedaTx2.value) {
          onResetAddrInputError();
          if (props.txBuilder) {
            addrInputError.value = "Milkomeda address not supported in TxBuilder, please use the normal guided send process!";
            return;
          }
          if (!milkomedaBridgeAddrValid2.value) {
            addrInputError.value = it(props.textId + ".error");
          } else {
            addAuxData2(txIndex.value, milkomedaAuxData2.value, true);
          }
        } else if (checkScriptAddr(addrInput.value)) ;
        else if (isAdaHandle(adaHandle.value) || entryInAddressBook.value && isAdaHandle(((_a = entryInAddressBook.value) == null ? void 0 : _a.name) ?? "")) ;
        else if (isUnstoppableDomain(unstoppabledomain.value) || entryInAddressBook.value && isUnstoppableDomain(((_b = entryInAddressBook.value) == null ? void 0 : _b.name) ?? "")) ;
        else {
          if (entryInAddressBook.value) {
            address = entryInAddressBook.value.address;
            addrAddressBook.value = address;
            addrInputAppend.value = "<span><b>" + it("common.label.addrbook") + ":</b></span> " + address;
          }
          if (!isValidSendAddress(networkId.value, address)) {
            addrInputError.value = it(props.textId + ".error");
            onResetOutput();
          } else {
            onResetAddrInputError();
          }
        }
      }
    };
    const validateAddr = () => {
      if (addrInputError.value.length === 0 && (addrInput.value.length > 0 && addrInput.value !== "$" || addrInput.value.length === 0 && props.canBeEmpty)) {
        isValidReceiveAddr.value = isValidSendAddress(networkId.value, addrInput.value) || isMilkomedaTx2.value;
        const _output = output.value;
        if (_output) {
          if (!isMilkomedaTx2.value) {
            _output.address = addrInput.value;
            _output.adaHandle = adaHandle.value;
            _output.adaHandleAddress = adaHandleAddress.value;
            _output.adaHandleAddressNew = adaHandleAddressNew.value;
            _output.unstoppabledomain = unstoppabledomain.value;
            _output.unstoppabledomainAddress = unstoppabledomainAddress.value;
            _output.unstoppabledomainAddressNew = unstoppabledomainAddressNew.value;
          } else {
            _output.address = milkomedaBridgeAddr2.value;
            _output.milkomedaBridgeAddr = milkomedaAddr2.value;
          }
        }
        return;
      }
      isValidReceiveAddr.value = false;
    };
    const checkScriptAddr = (address) => {
      isScriptAddr.value = isScriptAddress(address);
      if (isScriptAddr.value) {
        showScriptAddrModal.value = true;
        return true;
      }
      return false;
    };
    const checkAdaHandle = (address) => {
      var _a, _b;
      (_a = adaHandleResolve.value) == null ? void 0 : _a.reset();
      adaHandleAddress.value = "";
      adaHandleAddressNew.value = "";
      showAdaHandleResolve.value = false;
      if (isAdaHandle(address)) {
        adaHandle.value = address;
        showAdaHandleResolve.value = true;
        const entry = checkBookmarked();
        if (entry) {
          (_b = adaHandleResolve.value) == null ? void 0 : _b.doResolve(address);
        }
        return true;
      }
      adaHandle.value = "";
      return false;
    };
    const checkUnstoppableDomain = (address) => {
      unstoppabledomainAddress.value = "";
      unstoppabledomainAddressNew.value = "";
      unstoppabledomainShowResolve.value = false;
      if (isUnstoppableDomain(address)) {
        unstoppabledomain.value = address;
        unstoppabledomainShowResolve.value = true;
        const entry = checkBookmarked();
        if (entry) {
          doResolveUnstoppableDomain();
        }
        return true;
      }
      unstoppabledomain.value = "";
      return false;
    };
    const onClickResolveAdaHandle = () => {
      var _a;
      if (!adaHandleAddress.value) {
        (_a = adaHandleResolve.value) == null ? void 0 : _a.doResolve(addrInput.value);
      }
    };
    const doResolveUnstoppableDomain = async () => {
      if (!unstoppabledomainAddress.value) {
        try {
          const _address = await resolveUnstoppableDomain(networkId.value, selectedAccountId2.value, addrInput.value);
          addrInputError.value = "";
          unstoppabledomainAddress.value = _address;
          const entry = checkBookmarked();
          if (entry && entry.name === unstoppabledomain.value && entry.address !== _address) {
            unstoppabledomainAddressNew.value = _address;
          } else {
            unstoppabledomainAddressNew.value = "";
          }
          addrInput.value = _address;
        } catch (error) {
          console.error(error);
          unstoppabledomainAddress.value = "";
          addrInputAppend.value = "";
          addrInputError.value = getDefaultErrorMessage(error);
        }
      }
    };
    const onEnter = () => {
      if (adaHandle.value) {
        onClickResolveAdaHandle();
      } else if (unstoppabledomain.value) {
        doResolveUnstoppableDomain();
      } else {
        onAddrInputUpdate(addrInput.value);
      }
    };
    const onReset = () => {
      addrInput.value = "";
      onResetOutput();
    };
    const onResetOutput = () => {
      const _output = output.value;
      if (_output) {
        _output.address = "";
        _output.adaHandle = "";
        _output.adaHandleAddress = "";
        _output.adaHandleAddressNew = "";
        _output.milkomedaBridgeAddr = "";
        _output.unstoppabledomain = "";
        _output.unstoppabledomainAddress = "";
        _output.unstoppabledomainAddressNew = "";
      }
    };
    const onAdaHandleResolveError = (error, blocking = true) => {
      if (blocking) {
        adaHandleAddress.value = "";
        addrInputAppend.value = "";
      }
      if (error === "wallet.settings.changeaddr.error") {
        $q.notify({
          type: "warning",
          message: "Could not load ADA Handle verification image.",
          position: "top-left",
          timeout: 2e3
        });
      } else {
        addrInputError.value = getDefaultErrorMessage(error);
      }
    };
    const onAdaHandleResolve = (address) => {
      addrInputError.value = "";
      adaHandleAddress.value = address;
      const entry = checkBookmarked();
      if (entry && entry.name === adaHandle.value && entry.address !== address) {
        adaHandleAddressNew.value = address;
      } else {
        adaHandleAddressNew.value = "";
      }
      addrInput.value = address;
    };
    const onQrCode = (payload) => {
      if (payload.content) {
        addrInput.value = payload.content;
      }
    };
    const onSelectAddress = (entry) => {
      if (entry) {
        if (isAdaHandle(entry.name) || isUnstoppableDomain(entry.name)) {
          addrInput.value = entry.name;
        } else {
          addrInput.value = entry.address;
        }
      }
    };
    const onSelectAccountAddress = (addr) => {
      if (addr) {
        addrInput.value = addr;
      }
    };
    const checkBookmarked = () => {
      entryInAddressBook.value = addressBook.value.entryList.find((item) => item.name === adaHandle.value) ?? addressBook.value.entryList.find((item) => item.address === adaHandleAddress.value) ?? addressBook.value.entryList.find((item) => item.address === unstoppabledomain.value) ?? addressBook.value.entryList.find((item) => item.address === unstoppabledomainAddress.value) ?? addressBook.value.entryList.find((item) => item.address === addrInput.value) ?? null;
      if (entryInAddressBook.value) {
        if (isAdaHandle(entryInAddressBook.value.name)) {
          if (!adaHandle.value) {
            addrInput.value = entryInAddressBook.value.name;
          }
        } else if (isUnstoppableDomain(entryInAddressBook.value.name)) {
          if (!unstoppabledomain.value) {
            addrInput.value = entryInAddressBook.value.name;
          }
        }
      }
      return entryInAddressBook.value;
    };
    const onBookmarkAddress = async () => {
      checkBookmarked();
      let _name = null;
      let _address = null;
      if (isAdaHandle(adaHandle.value)) {
        _name = adaHandle.value;
        _address = adaHandleAddress.value;
      } else if (isUnstoppableDomain(unstoppabledomain.value)) {
        _name = unstoppabledomain.value;
        _address = unstoppabledomainAddress.value;
      }
      if (_name && _address) {
        const success = await updateAddressBookEntry(networkId.value, _name, _address);
        $q.notify({
          type: success ? "positive" : "negative",
          message: success ? it("setting.addressbook.add.title.success").replace("###name###", _name) : it("setting.addressbook.add.title.error").replace("###name###", _name),
          position: "top-left",
          timeout: 2e3
        });
        onMaybeBookmarkAdded();
      } else {
        showAddBookmarkModal.value.display = true;
      }
    };
    const onMaybeBookmarkAdded = () => {
      checkBookmarked();
    };
    onMounted(() => {
      addSignalListener(onAddressBookEntryDeleted, storeId, checkBookmarked);
      addSignalListener(onAddressBookEntryUpdated, storeId, checkBookmarked);
      nextTick(() => {
        var _a;
        (_a = textAreaField.value) == null ? void 0 : _a.focus();
      });
      setMilkomedaAddress2("");
    });
    onUnmounted(() => {
      removeSignalListener(onAddressBookEntryDeleted, storeId);
      removeSignalListener(onAddressBookEntryUpdated, storeId);
    });
    let _toid = -1;
    watch(addrInput, (value, oldValue) => {
      clearTimeout(_toid);
      if (value.length === 0) {
        onResetOutput();
        onAddrInputUpdate(value);
        return;
      }
      if (value !== oldValue && !isDonation.value) {
        let doReset = false;
        if (value.length === oldValue.length) {
          doReset = true;
        }
        if (value.length > oldValue.length) {
          if (!value.startsWith(oldValue)) {
            doReset = true;
          }
        }
        if (value.length < oldValue.length) {
          if (!oldValue.startsWith(value)) {
            doReset = true;
          }
        }
        if (doReset && (isAdaHandle(value) || isUnstoppableDomain(value))) {
          checkAdaHandle("");
          checkUnstoppableDomain("");
          onResetOutput();
        }
        _toid = setTimeout(() => {
          onAddrInputUpdate(value);
        }, 333);
      }
    });
    watch(() => output.value, (value, oldValue) => {
      var _a;
      if (value) {
        adaHandle.value = value.adaHandle;
        adaHandleAddress.value = "";
        adaHandleAddressNew.value = "";
        unstoppabledomain.value = value.unstoppabledomain;
        unstoppabledomainAddress.value = "";
        unstoppabledomainAddressNew.value = "";
        if (isAdaHandle(adaHandle.value)) {
          (_a = adaHandleResolve.value) == null ? void 0 : _a.doResolve(adaHandle.value);
        } else if (isUnstoppableDomain(unstoppabledomain.value)) {
          doResolveUnstoppableDomain();
        } else {
          addrInput.value = value.address;
        }
      }
    }, { immediate: true });
    return (_ctx, _cache) => {
      var _a, _b, _c, _d;
      return unref(accountData2) ? (openBlock(), createElementBlock("div", _hoisted_1$9, [
        createBaseVNode("div", _hoisted_2$8, [
          createBaseVNode("div", _hoisted_3$7, [
            !__props.disabled ? (openBlock(), createElementBlock("div", _hoisted_4$6, [
              !isDonation.value ? (openBlock(), createElementBlock("span", _hoisted_5$3, toDisplayString(unref(outputIndex) + 1), 1)) : (openBlock(), createElementBlock("span", _hoisted_6$2, _cache[5] || (_cache[5] = [
                createBaseVNode("i", { class: "mdi mdi-heart text-xl text-red-500" }, null, -1)
              ]))),
              isDonation.value ? (openBlock(), createElementBlock("span", _hoisted_7, "Thank you for supporting Eternl!")) : createCommentVNode("", true),
              unref(txIndex) > 0 ? (openBlock(), createElementBlock("span", _hoisted_8, " (" + toDisplayString(unref(txIndex) + 1) + ")", 1)) : createCommentVNode("", true)
            ])) : (openBlock(), createElementBlock("div", _hoisted_9, _cache[6] || (_cache[6] = [
              createBaseVNode("span", null, "Change", -1)
            ]))),
            adaHandle.value ? (openBlock(), createElementBlock("div", {
              key: 2,
              class: normalizeClass([
                "relative px-2 sm:px-3 py-1 max-w-[15rem] flex justify-center items-center break-all",
                " cc-text-medium rounded-md text-white ring-1 ring-handlehighlight/30",
                adaHandleAddress.value ? "bg-handle" : "bg-neutral-700 "
              ])
            }, [
              createBaseVNode("div", {
                class: normalizeClass([!adaHandleAddress.value || adaHandleResolving.value ? "grayscale" : ""])
              }, [
                _cache[7] || (_cache[7] = createBaseVNode("span", {
                  class: "cc-text-extra-bold cc-text-sx -ml-px",
                  style: { "color": "#60cd69" }
                }, "$", -1)),
                createBaseVNode("span", _hoisted_10, toDisplayString(adaHandle.value.substring(1)), 1)
              ], 2),
              createVNode(Transition, { name: "fade" }, {
                default: withCtx(() => [
                  !adaHandleAddress.value && addrInputError.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_11, _cache[8] || (_cache[8] = [
                    createBaseVNode("i", { class: "absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 mdi mdi-close text-xs" }, null, -1)
                  ]))) : !adaHandleAddress.value ? (openBlock(), createElementBlock("div", _hoisted_12, _cache[9] || (_cache[9] = [
                    createBaseVNode("div", { class: "relative -mt-px" }, [
                      createBaseVNode("div", { class: "relative ml-px -mt-0.5" }, [
                        createBaseVNode("i", { class: "mdi mdi-alert-octagon-outline text-sm" })
                      ])
                    ], -1)
                  ]))) : adaHandleAddress.value && adaHandleAddressNew.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_13, _cache[10] || (_cache[10] = [
                    createBaseVNode("div", { class: "relative -mt-px" }, [
                      createBaseVNode("div", { class: "relative ml-px -mt-0.5" }, [
                        createBaseVNode("i", { class: "mdi mdi-alert-octagon-outline text-sm" })
                      ])
                    ], -1)
                  ]))) : (openBlock(), createElementBlock("div", _hoisted_14, _cache[11] || (_cache[11] = [
                    createBaseVNode("i", { class: "absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 mdi mdi-check text-xs" }, null, -1)
                  ])))
                ]),
                _: 1
              })
            ], 2)) : unstoppabledomain.value ? (openBlock(), createElementBlock("div", {
              key: 3,
              class: normalizeClass([
                "relative px-2 sm:px-3 py-1 max-w-[15rem] flex justify-center items-center break-all",
                " cc-text-medium rounded-md text-white ring-1 ring-handlehighlight/30",
                unstoppabledomainAddress.value ? "bg-handle" : "bg-neutral-700 "
              ])
            }, [
              createBaseVNode("div", {
                class: normalizeClass([!unstoppabledomainAddress.value || unstoppabledomainResolving.value ? "grayscale" : ""])
              }, [
                createBaseVNode("span", _hoisted_15, toDisplayString(unstoppabledomain.value), 1)
              ], 2),
              createVNode(Transition, { name: "fade" }, {
                default: withCtx(() => [
                  !unstoppabledomainAddress.value && addrInputError.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_16, _cache[12] || (_cache[12] = [
                    createBaseVNode("i", { class: "absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 mdi mdi-close text-xs" }, null, -1)
                  ]))) : !unstoppabledomainAddress.value ? (openBlock(), createElementBlock("div", _hoisted_17, _cache[13] || (_cache[13] = [
                    createBaseVNode("div", { class: "relative -mt-px" }, [
                      createBaseVNode("div", { class: "relative ml-px -mt-0.5" }, [
                        createBaseVNode("i", { class: "mdi mdi-alert-octagon-outline text-sm" })
                      ])
                    ], -1)
                  ]))) : unstoppabledomainAddress.value && unstoppabledomainAddressNew.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_18, _cache[14] || (_cache[14] = [
                    createBaseVNode("div", { class: "relative -mt-px" }, [
                      createBaseVNode("div", { class: "relative ml-px -mt-0.5" }, [
                        createBaseVNode("i", { class: "mdi mdi-alert-octagon-outline text-sm" })
                      ])
                    ], -1)
                  ]))) : (openBlock(), createElementBlock("div", _hoisted_19, _cache[15] || (_cache[15] = [
                    createBaseVNode("i", { class: "absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 mdi mdi-check text-xs" }, null, -1)
                  ])))
                ]),
                _: 1
              })
            ], 2)) : createCommentVNode("", true),
            showAdaHandleResolve.value && !adaHandleAddress.value ? (openBlock(), createElementBlock("button", {
              key: 4,
              class: normalizeClass([
                "px-2 sm:px-3 flex flex-row flex-nowrap justify-center items-center space-x-1 cc-text-medium rounded-md text-white cursor-pointer",
                !adaHandleAddress.value ? "bg-handle hover:ring-1 ring-handlehighlight" : "bg-neutral-700 grayscale"
              ]),
              disabled: adaHandleAddress.value.length > 0 || adaHandle.value.length < 2 || adaHandleResolving.value,
              onClick: withModifiers(onClickResolveAdaHandle, ["prevent", "stop"])
            }, [
              createBaseVNode("i", {
                class: normalizeClass(["mdi mdi-update", adaHandleResolving.value ? "animate-spin" : ""]),
                style: { "color": "#60cd69" }
              }, null, 2),
              createBaseVNode("div", null, toDisplayString(unref(it)("common.label.resolve")), 1)
            ], 10, _hoisted_20)) : unstoppabledomainShowResolve.value && !unstoppabledomainAddress.value ? (openBlock(), createElementBlock("button", {
              key: 5,
              class: normalizeClass([
                "px-2 sm:px-3 flex flex-row flex-nowrap justify-center items-center space-x-1 cc-text-medium rounded-md text-white cursor-pointer",
                !unstoppabledomainAddress.value ? "bg-handle hover:ring-1 ring-handlehighlight" : "bg-neutral-700 grayscale"
              ]),
              disabled: unstoppabledomainAddress.value.length > 0 || unstoppabledomain.value.length < 2 || unstoppabledomainResolving.value,
              onClick: withModifiers(doResolveUnstoppableDomain, ["prevent", "stop"])
            }, [
              createBaseVNode("i", {
                class: normalizeClass(["mdi mdi-update", unstoppabledomainResolving.value ? "animate-spin" : ""]),
                style: { "color": "#60cd69" }
              }, null, 2),
              createBaseVNode("div", null, toDisplayString(unref(it)("common.label.resolve")), 1)
            ], 10, _hoisted_21)) : createCommentVNode("", true),
            entryInAddressBook.value ? (openBlock(), createElementBlock("div", _hoisted_22, [
              createBaseVNode("div", null, [
                createVNode(IconBook, { class: "h-4 -ml-0.5 mt-px" })
              ]),
              createBaseVNode("div", _hoisted_23, toDisplayString(entryInAddressBook.value.name), 1)
            ])) : createCommentVNode("", true),
            isSameAccount.value && appAccountName.value ? (openBlock(), createElementBlock("div", _hoisted_24, [
              createBaseVNode("div", _hoisted_25, toDisplayString(appAccountName.value), 1)
            ])) : isSameAccount.value ? (openBlock(), createElementBlock("div", _hoisted_26, _cache[16] || (_cache[16] = [
              createBaseVNode("div", { class: "cc-text-bold cc-text-sx" }, "Same Account", -1)
            ]))) : isSameWallet.value && walletName.value ? (openBlock(), createElementBlock("div", _hoisted_27, [
              createBaseVNode("div", _hoisted_28, toDisplayString(walletName.value) + ": " + toDisplayString(appAccountName.value), 1)
            ])) : walletName.value ? (openBlock(), createElementBlock("div", _hoisted_29, [
              createBaseVNode("div", _hoisted_30, toDisplayString(walletName.value) + ": " + toDisplayString(appAccountName.value), 1)
            ])) : createCommentVNode("", true),
            unref(isMilkomedaTx2) ? (openBlock(), createElementBlock("div", _hoisted_31, _cache[17] || (_cache[17] = [
              createBaseVNode("div", { class: "cc-text-bold cc-text-sx" }, " Milkomeda C1 Address ", -1)
            ]))) : createCommentVNode("", true)
          ]),
          createBaseVNode("div", _hoisted_32, [
            !isDonation.value && !__props.disabled ? (openBlock(), createBlock(_sfc_main$b, {
              key: 0,
              "text-id": __props.textId,
              onSelect: onSelectAccountAddress
            }, null, 8, ["text-id"])) : createCommentVNode("", true),
            !isDonation.value && !__props.disabled && !entryInAddressBook.value && isValidReceiveAddr.value ? (openBlock(), createBlock(_sfc_main$c, {
              key: 1,
              class: "cml",
              onClick: withModifiers(onBookmarkAddress, ["prevent", "stop"])
            })) : createCommentVNode("", true),
            !isDonation.value && !__props.disabled ? (openBlock(), createBlock(_sfc_main$e, {
              key: 2,
              "text-id": __props.textId,
              class: "cml",
              onSelect: onSelectAddress
            }, null, 8, ["text-id"])) : createCommentVNode("", true),
            !isDonation.value && !__props.disabled ? (openBlock(), createBlock(_sfc_main$q, {
              key: 3,
              class: "relative min-w-0 cml inline-flex flex-row flex-nowrap justify-center items-center cursor-pointer focus:outline-none text-sm cc-text-bold cc-btn-secondary",
              onDecode: onQrCode
            }, {
              default: withCtx(() => [
                createVNode(_sfc_main$n, {
                  anchor: "top middle",
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)(__props.textId + ".qrcode.show")), 1)
                  ]),
                  _: 1
                })
              ]),
              _: 1
            })) : createCommentVNode("", true),
            numOutputs.value > 1 && !__props.disabled ? (openBlock(), createElementBlock("button", {
              key: 4,
              class: "relative min-w-0 cml w-7 sm:w-9 inline-flex flex-row flex-nowrap justify-center items-center cursor-pointer focus:outline-none cc-text-sx cc-text-bold cc-btn-warning-light",
              onClick: withModifiers(onRemoveOutput, ["stop", "prevent"])
            }, [
              _cache[18] || (_cache[18] = createBaseVNode("i", { class: "mdi mdi-trash-can-outline drop-shadow text-lg sm:text-xl -mt-0.5 sm:mt-0" }, null, -1)),
              createVNode(_sfc_main$n, {
                anchor: "top middle",
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(unref(it)(__props.textId + ".delete")), 1)
                ]),
                _: 1
              })
            ])) : createCommentVNode("", true)
          ])
        ]),
        createBaseVNode("div", _hoisted_33, [
          createBaseVNode("div", _hoisted_34, [
            createBaseVNode("div", _hoisted_35, [
              createBaseVNode("div", _hoisted_36, [
                unref(output) ? (openBlock(), createBlock(GridInput, {
                  key: 0,
                  "input-text": addrInput.value,
                  "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => addrInput.value = $event),
                  "input-error": addrInputError.value,
                  "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => addrInputError.value = $event),
                  class: "col-span-12 break-words break-all",
                  "input-c-s-s": !outputAddress.value && unref(output).amount.coin !== "0" ? " cc-input-yellow cc-input  " : " cc-input ",
                  "input-text-c-s-s": "grow h-20 min-h-10 max-h-20 text-italic font-mono\n                                                    text-xs xxs:text-sm leading-snug sm:leading-snug",
                  "input-id": "inputAddress_" + unref(txIndex) + "_" + unref(outputIndex),
                  "input-type": "text",
                  "always-show-info": false,
                  rows: 1,
                  "input-hint": unref(it)(__props.textId + ".hint"),
                  "input-info-append": addrInputAppend.value,
                  inputDisabled: isDonation.value || __props.disabled,
                  "show-reset": !isDonation.value && !__props.disabled,
                  "multiline-input": "",
                  "prevent-enter": "",
                  onReset,
                  onEnter
                }, null, 8, ["input-text", "input-error", "input-c-s-s", "input-id", "input-hint", "input-info-append", "inputDisabled", "show-reset"])) : createCommentVNode("", true),
                createVNode(_sfc_main$f, {
                  ref_key: "adaHandleResolve",
                  ref: adaHandleResolve,
                  "show-address": false,
                  onResolved: onAdaHandleResolve,
                  onError: onAdaHandleResolveError,
                  class: normalizeClass(["grow-0 shrink-0", adaHandleAddress.value ? "mt-1.5 xxxs:mt-0 sm:mt-0 ml-0 xxxs:ml-1 sm:ml-2 w-20 h-20" : "hidden ml-0 mt-0 w-0 h-20"])
                }, null, 8, ["class"]),
                unstoppabledomainAddress.value ? (openBlock(), createElementBlock("img", {
                  key: 1,
                  src: unref(unstoppabledomainsLogo2),
                  class: "rounded grow-0 shrink-0 mt-1.5 xxxs:mt-0 sm:mt-0 ml-0 xxxs:ml-1 sm:ml-2 w-20 h-20",
                  alt: "Unstoppable Domains"
                }, null, 8, _hoisted_37)) : createCommentVNode("", true)
              ])
            ]),
            adaHandleAddressNew.value.length > 0 ? (openBlock(), createBlock(_sfc_main$r, {
              key: 0,
              label: unref(it)("wallet.send.step.receiveAddr.resolve.change.label").replace("###NAME###", "ADA Handle"),
              text: unref(it)("wallet.send.step.receiveAddr.resolve.change.text").replace(/###TYPE###/g, "ADA Handle").replace("###HANDLE###", ((_a = entryInAddressBook.value) == null ? void 0 : _a.name) ?? "").replace("####OLD####", ((_b = entryInAddressBook.value) == null ? void 0 : _b.address) ?? "").replace("####NEW####", adaHandleAddressNew.value) + "\n\n" + unref(it)("wallet.send.step.receiveAddr.resolve.text").replace(/###TYPE###/g, "ADA Handle"),
              icon: unref(it)(__props.textId + ".resolve.change.icon"),
              "is-info": "",
              class: "col-span-12 pt-0.5 cursor-pointer",
              "label-css": "ml-1",
              "text-c-s-s": "cc-text-normal text-justify  break-words",
              css: "cc-rounded cc-banner-red"
            }, null, 8, ["label", "text", "icon"])) : adaHandleAddress.value ? (openBlock(), createBlock(_sfc_main$r, {
              key: 1,
              label: unref(it)("wallet.send.step.receiveAddr.resolve.label").replace("###NAME###", "ADA Handle"),
              text: unref(it)("wallet.send.step.receiveAddr.resolve.text").replace(/###TYPE###/g, "ADA Handle"),
              icon: unref(it)("wallet.send.step.receiveAddr.resolve.icon"),
              "start-collapsed": !!entryInAddressBook.value,
              "is-info": "",
              html: "",
              class: "col-span-12 pt-0.5 cursor-pointer",
              "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
              "label-css": "ml-1",
              css: "cc-rounded cc-banner-warning"
            }, null, 8, ["label", "text", "icon", "start-collapsed"])) : unstoppabledomainAddressNew.value.length > 0 ? (openBlock(), createBlock(_sfc_main$r, {
              key: 2,
              label: unref(it)("wallet.send.step.receiveAddr.resolve.change.label").replace("###NAME###", "Unstoppable Domains"),
              text: unref(it)("wallet.send.step.receiveAddr.resolve.change.text").replace(/###TYPE###/g, "domain").replace("###HANDLE###", ((_c = entryInAddressBook.value) == null ? void 0 : _c.name) ?? "").replace("####OLD####", ((_d = entryInAddressBook.value) == null ? void 0 : _d.address) ?? "").replace("####NEW####", unstoppabledomainAddressNew.value) + "\n\n" + unref(it)("wallet.send.step.receiveAddr.resolve.text").replace(/###TYPE###/g, "domain"),
              icon: unref(it)(__props.textId + ".resolve.change.icon"),
              "is-info": "",
              class: "col-span-12 pt-0.5 cursor-pointer",
              "label-css": "ml-1",
              "text-c-s-s": "cc-text-normal text-justify  break-words",
              css: "cc-rounded cc-banner-red"
            }, null, 8, ["label", "text", "icon"])) : unstoppabledomainAddress.value ? (openBlock(), createBlock(_sfc_main$r, {
              key: 3,
              label: unref(it)("wallet.send.step.receiveAddr.resolve.label").replace("###NAME###", "Unstoppable Domains"),
              text: unref(it)("wallet.send.step.receiveAddr.resolve.text").replace(/###TYPE###/g, "domain"),
              icon: unref(it)("wallet.send.step.receiveAddr.resolve.icon"),
              "start-collapsed": !!entryInAddressBook.value,
              "is-info": "",
              html: "",
              class: "col-span-12 pt-0.5 cursor-pointer",
              "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
              "label-css": "ml-1",
              css: "cc-rounded cc-banner-warning"
            }, null, 8, ["label", "text", "icon", "start-collapsed"])) : createCommentVNode("", true)
          ])
        ]),
        showScammerWarning.value ? (openBlock(), createElementBlock("div", _hoisted_38, [
          createBaseVNode("div", _hoisted_39, [
            createBaseVNode("div", _hoisted_40, toDisplayString(unref(it)("common.scam.guard.warning")), 1),
            createBaseVNode("div", _hoisted_41, toDisplayString(unref(it)("common.scam.address.description")), 1),
            createBaseVNode("div", {
              class: "col-span-full mt-2 w-full max-w-full mb-2",
              innerHTML: unref(it)("common.scam.address.description2")
            }, null, 8, _hoisted_42)
          ])
        ])) : createCommentVNode("", true),
        unref(isMilkomedaTx2) ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: "relative grow min-w-0 flex flex-col flex-nowrap justify-start items-start mt-2",
          innerHTML: unref(milkomedaAddrAppend2)
        }, null, 8, _hoisted_43)) : createCommentVNode("", true),
        unref(isMilkomedaTx2) ? (openBlock(), createElementBlock("div", _hoisted_44, [
          createVNode(_sfc_main$s, {
            "label-hover": unref(it)("wallet.transactions.button.copy.address.hover"),
            "copy-text": unref(milkomedaBridgeAddr2),
            "notification-text": unref(it)("wallet.transactions.button.copy.address.notify"),
            class: "inline-flex items-center justify-center"
          }, null, 8, ["label-hover", "copy-text", "notification-text"]),
          createVNode(_sfc_main$t, {
            subject: { bech32: unref(milkomedaBridgeAddr2) },
            type: "address",
            truncate: false,
            label: unref(milkomedaBridgeAddr2),
            "label-c-s-s": "cc-addr break-all",
            class: "text-right"
          }, null, 8, ["subject", "label"])
        ])) : createCommentVNode("", true),
        unref(isMilkomedaTx2) ? (openBlock(), createElementBlock("div", {
          key: 3,
          class: "relative grow min-w-0 flex flex-col flex-nowrap justify-start items-start",
          innerHTML: unref(milkomedaFeeAppend2)
        }, null, 8, _hoisted_45)) : createCommentVNode("", true),
        unref(isMilkomedaTx2) ? (openBlock(), createElementBlock("div", _hoisted_46, [
          createVNode(_sfc_main$r, {
            label: unref(it)("wallet.send.step.receiveAddr.milkomeda.label"),
            text: unref(it)("wallet.send.step.receiveAddr.milkomeda.text"),
            icon: unref(it)("wallet.send.step.receiveAddr.milkomeda.icon"),
            html: "",
            class: "col-span-12 mt-2",
            "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
            css: "cc-rounded cc-banner-warning"
          }, null, 8, ["label", "text", "icon"])
        ])) : createCommentVNode("", true),
        showScriptAddrModal.value ? (openBlock(), createBlock(Modal, {
          key: 5,
          narrow: "",
          "full-width-on-mobile": "",
          onClose: _cache[4] || (_cache[4] = ($event) => showScriptAddrModal.value = false)
        }, {
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_47, [
              createVNode(_sfc_main$r, {
                label: unref(it)(__props.textId + ".script.label"),
                text: unref(it)(__props.textId + ".script.text"),
                class: "col-span-12",
                "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
                css: "cc-rounded cc-banner-warning"
              }, null, 8, ["label", "text"]),
              createBaseVNode("div", _hoisted_48, [
                createVNode(_sfc_main$u, {
                  label: unref(it)("common.label.cancel"),
                  onClick: _cache[2] || (_cache[2] = ($event) => showScriptAddrModal.value = false),
                  "btn-style": "cc-text-md cc-btn-warning-light",
                  class: "col-span-6"
                }, null, 8, ["label"]),
                createVNode(GridButtonSecondary, {
                  label: unref(it)("common.label.confirm"),
                  onClick: _cache[3] || (_cache[3] = ($event) => {
                    showScriptAddrModal.value = false;
                  }),
                  class: "col-span-6"
                }, null, 8, ["label"])
              ])
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        showAddBookmarkModal.value.display ? (openBlock(), createBlock(_sfc_main$v, {
          key: 6,
          "show-modal": showAddBookmarkModal.value,
          title: unref(it)("common.label.addrbook"),
          caption: unref(it)("setting.addressbook.add.title.caption"),
          "show-addr-input": false,
          "old-addr": addrInput.value,
          onSubmit: onMaybeBookmarkAdded,
          onClose: onMaybeBookmarkAdded
        }, null, 8, ["show-modal", "title", "caption", "old-addr"])) : createCommentVNode("", true)
      ])) : createCommentVNode("", true);
    };
  }
});
const SendOutputAddress = /* @__PURE__ */ _export_sfc(_sfc_main$a, [["__scopeId", "data-v-4212beca"]]);
const _hoisted_1$8 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_2$7 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$6 = { class: "grid grid-cols-12 cc-gap w-full p-2 sm:p-4" };
const _hoisted_4$5 = { class: "grid grid-cols-12 cc-gap w-full p-2 border-t" };
const _sfc_main$9 = /* @__PURE__ */ defineComponent({
  __name: "TokenModal",
  props: {
    showModal: { type: Object, required: true },
    title: { type: String, required: false, default: void 0 },
    caption: { type: String, required: false, default: void 0 },
    persistent: { type: Boolean, required: false, default: false },
    isMilkomedaTx: { type: Boolean, required: false, default: false },
    inputMultiAsset: { type: Object, required: false, default: void 0 },
    showSelectedAssetList: { type: Boolean, required: false, default: false },
    confirmLabel: { type: String, required: false, default: void 0 },
    hideConfirm: { type: Boolean, required: false, default: false },
    assetToSendList: { type: Array, required: false, default: "" },
    extLinkLabel: { type: String, required: false, default: "" },
    disabled: { type: Boolean, required: false, default: false }
  },
  emits: ["close", "confirm", "onAssetUpdateEvent"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { showModal } = toRefs(props);
    const confirmLabel = ref(props.confirmLabel);
    if (props.confirmLabel === void 0) {
      confirmLabel.value = it("common.label.done");
    }
    const onAssetUpdateEvent = async (type, e) => {
      emit("onAssetUpdateEvent", type, e);
    };
    const onConfirm = () => {
      showModal.value.display = false;
      emit("confirm");
    };
    const onClose = () => {
      showModal.value.display = false;
      emit("close");
    };
    return (_ctx, _cache) => {
      var _a;
      return ((_a = unref(showModal)) == null ? void 0 : _a.display) ? (openBlock(), createBlock(Modal, {
        key: 0,
        persistent: false,
        onClose
      }, createSlots({
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1$8, [
            createBaseVNode("div", _hoisted_2$7, [
              createVNode(_sfc_main$k, {
                label: __props.title,
                "do-capitalize": false
              }, null, 8, ["label"])
            ])
          ])
        ]),
        content: withCtx(() => [
          createBaseVNode("div", _hoisted_3$6, [
            __props.inputMultiAsset ? (openBlock(), createBlock(_sfc_main$x, {
              key: 0,
              "token-selected-list": __props.assetToSendList,
              "multi-asset": __props.inputMultiAsset,
              "filter-by-selected": __props.showSelectedAssetList,
              "milkomeda-view": __props.isMilkomedaTx,
              "max-cols": 4,
              disabled: __props.disabled,
              onAddAsset: _cache[0] || (_cache[0] = ($event) => onAssetUpdateEvent("add", $event)),
              onDelAsset: _cache[1] || (_cache[1] = ($event) => onAssetUpdateEvent("del", $event)),
              "send-enabled": ""
            }, null, 8, ["token-selected-list", "multi-asset", "filter-by-selected", "milkomeda-view", "disabled"])) : createCommentVNode("", true)
          ])
        ]),
        _: 2
      }, [
        !__props.hideConfirm ? {
          name: "footer",
          fn: withCtx(() => [
            createBaseVNode("div", _hoisted_4$5, [
              createVNode(_sfc_main$w, {
                label: confirmLabel.value,
                link: onConfirm,
                class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
              }, null, 8, ["label"])
            ])
          ]),
          key: "0"
        } : void 0
      ]), 1024)) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$7 = { class: "text-md ml-1.5" };
const _hoisted_2$6 = ["disabled"];
const adaInputDefault = "";
const _sfc_main$8 = /* @__PURE__ */ defineComponent({
  __name: "SendOutputAssets",
  props: {
    textId: { type: String, required: true, default: "wallet.send.step.receiveAddr" },
    txIndex: { type: Number, required: true },
    outputIndex: { type: Number, required: true },
    disabled: { type: Boolean, required: false, default: false }
  },
  emits: ["submit", "reset"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const storeId = "SendOutputAssets" + getRandomId();
    const {
      txIndex,
      outputIndex
    } = toRefs(props);
    const $q = useQuasar();
    const { it } = useTranslation();
    const {
      formatADAString,
      getNetworkDecimals,
      getDecimalNumber,
      valueFromFormattedString,
      getNumberFormatSeparators
    } = useFormatter();
    const { adaSymbol } = useAdaSymbol();
    const {
      appAccount: appAccount2,
      accountData: accountData2,
      stagingTx,
      output,
      accountSettings: accountSettings2,
      accountBalances
    } = useAppAccountTxLists(txIndex, outputIndex);
    const isSendAllEnabled = accountSettings2.isSendAllEnabled;
    const numOutputs = computed(() => {
      var _a;
      return ((_a = stagingTx.value) == null ? void 0 : _a.body.outputs.length) ?? 0;
    });
    const outputAddress = computed(() => {
      var _a;
      return ((_a = output.value) == null ? void 0 : _a.address) ?? "";
    });
    const auxData = computed(() => {
      var _a;
      return ((_a = stagingTx.value) == null ? void 0 : _a.auxiliary_data) ?? null;
    });
    const isDonation = computed(() => {
      var _a;
      const addr = outputAddress.value;
      const _networkId = (_a = accountData2.value) == null ? void 0 : _a.state.networkId;
      if (!addr || !_networkId) {
        return false;
      }
      const donationAddr = getDonationAddress(_networkId);
      return addr === donationAddr;
    });
    const isLargeOutput = computed(() => {
      if (output.value) {
        const epochParams = checkEpochParams(networkId.value);
        if (epochParams && output.value.cborSize >= epochParams.maxValueSize - 100) {
          return true;
        }
      }
      return false;
    });
    const {
      isMilkomedaTx: isMilkomedaTx2,
      milkomedaMinLovelace: milkomedaMinLovelace2
    } = useMilkomeda(ref({ address: "" }));
    const availableOutputBalance = ref(createIBalance());
    const maxBtnDisabled = ref(false);
    computed(() => {
      var _a, _b, _c, _d, _e;
      if ((_a = accountData2.value) == null ? void 0 : _a.settings.tf.enabled) {
        return subtract(((_b = accountBalances.value) == null ? void 0 : _b.lockedAvailableTF.total) ?? "0", ((_c = accountBalances.value) == null ? void 0 : _c.txFees.total) ?? "0");
      } else {
        return subtract(((_d = accountBalances.value) == null ? void 0 : _d.lockedAvailable.total) ?? "0", ((_e = accountBalances.value) == null ? void 0 : _e.txFees.total) ?? "0");
      }
    });
    const networkDecimals = computed(() => getNetworkDecimals(networkId.value));
    let formatSeparators = getNumberFormatSeparators();
    const decimalSeparator = ref(formatSeparators.decimal);
    const groupSeparator = ref(formatSeparators.group);
    watch(appLanguageTag, () => {
      formatSeparators = getNumberFormatSeparators();
      decimalSeparator.value = formatSeparators.decimal;
      groupSeparator.value = formatSeparators.group;
      onReset();
    }, { deep: true });
    const isValidTxBody = ref(false);
    const adaInput = ref(adaInputDefault);
    const adaInputError = ref("");
    const adaInputInfo = ref("");
    const adaInputShowInfo = ref(false);
    const manualUpdate = ref(0);
    const isHigherThanUsualFee = ref(false);
    const isFirstAllPass = ref(-1);
    const txFee = ref("0");
    const getLovelace = (whole, fraction) => {
      while (fraction.length < 6) {
        fraction = fraction + "0";
      }
      return whole + fraction;
    };
    const validateAdaInput = (value) => {
      if (!accountData2.value) {
        return;
      }
      if (value) {
        adaInputError.value = "";
        const ada = valueFromFormattedString(value, networkDecimals.value, true);
        manualUpdate.value = manualUpdate.value + 1;
        nextTick(() => {
          adaInput.value = formatADAString(getLovelace(ada.whole, ada.fraction));
          updateStagingTx("", true);
        });
      } else {
        manualUpdate.value = manualUpdate.value + 1;
        adaInput.value = adaInputDefault;
        nextTick(() => {
          updateStagingTx("", true);
        });
      }
    };
    const onAddAllAda = async (isFirstPass = true, offset) => {
      var _a;
      if (!accountData2.value) {
        return;
      }
      if (!output.value) {
        return;
      }
      maxBtnDisabled.value = true;
      setTimeout(() => {
        maxBtnDisabled.value = false;
      }, 1e3);
      if (offset === "0") {
        _lastMissingFee = "";
      }
      updateAvailableOutputBalance(accountBalances.value, ((_a = appAccount2.value) == null ? void 0 : _a.id) ?? "");
      adaInputError.value = "";
      manualUpdate.value = manualUpdate.value + 1;
      if (isFirstPass) {
        isFirstAllPass.value = isFirstPass ? 1 : -1;
        const totalBalance = createIBalance(availableOutputBalance.value);
        addValueToValue(totalBalance, { coin: offset }, true);
        updateBalanceTotal(totalBalance);
        if (isLessThanZero(totalBalance.total)) {
          totalBalance.total = "0";
        }
        adaInput.value = formatADAString(totalBalance.total);
        await updateStagingTx("", true);
      } else if (!isZero(offset)) {
        const ada = valueFromFormattedString(adaInput.value, networkDecimals.value, true);
        let lovelace = getLovelace(ada.whole, ada.fraction);
        lovelace = subtract(lovelace, offset);
        adaInput.value = formatADAString(lovelace);
        await updateStagingTx("", true);
      }
    };
    const isStatic = ref(false);
    const assetToSendList = ref([]);
    const showAssetInput = ref({ display: assetToSendList.value.length > 0 });
    const showSelectedAssetList = ref(false);
    const displayAssetInput = () => {
      showAssetInput.value.display = true;
    };
    const inputMultiAsset = computed(() => availableOutputBalance.value.multiasset);
    const hasAvailableAssets = computed(() => !!inputMultiAsset.value && Object.keys(inputMultiAsset.value).length > 0);
    const onAssetUpdateEvent = async (type, e) => {
      switch (type) {
        case "add":
          if (isMilkomedaTx2.value && (assetToSendList.value.length >= 1 || Array.isArray(e) && e.length >= 2)) {
            $q.notify({
              color: "primary",
              textColor: "white",
              message: it("wallet.summary.token.milkomeda.tokenLimit"),
              position: "top-left"
            });
          } else {
            Array.isArray(e) ? assetToSendList.value.push(...e) : assetToSendList.value.push(e);
          }
          break;
        case "del":
          if (!e) {
            assetToSendList.value.splice(0);
          } else {
            const index = assetToSendList.value.findIndex((a) => a.p === e.p && a.t.a === e.t.a);
            if (index >= 0) {
              assetToSendList.value.splice(index, 1);
            }
          }
          break;
        case void 0:
          break;
        default:
          throw new Error("Error: onAssetUpdateEvent: unknown operation.");
      }
      if (assetToSendList.value.length === 0) {
        showSelectedAssetList.value = false;
      }
      if (!type) {
        adaInputError.value = "";
        updateStagingTx("add");
      }
    };
    const setTxInvalid = () => {
      isValidTxBody.value = adaInputError.value === "" && adaInput.value !== adaInputDefault;
      txFee.value = "0";
    };
    const getMinUtxoValue = () => {
      const epochParams = checkEpochParams(networkId.value);
      if (!epochParams) {
        return "0";
      }
      return getMinUtxo(output.value, epochParams.utxoCostPerSize, epochParams.isAtLeastBabbageEra);
    };
    const updateStagingTx = async (updateTokenType = "", updateImmediately = false) => {
      if (!output.value) {
        return false;
      }
      if (updateTokenType) {
        let minUtxoValue = getMinUtxoValue();
        let ada2 = valueFromFormattedString(adaInput.value, networkDecimals.value, true);
        let currentCoin = isZero(ada2.number) ? "0" : getLovelace(ada2.whole, ada2.fraction);
        const isSetToMinValue = compare(currentCoin, "<=", minUtxoValue);
        replaceMultiAssetInValue(output.value.amount, convertIAssetSendableListToMultiAssetJSON(assetToSendList.value));
        minUtxoValue = getMinUtxoValue();
        if (isSetToMinValue) {
          nextTick(() => {
            validateAdaInput(formatADAString(minUtxoValue));
          });
          return false;
        }
      }
      let ada = valueFromFormattedString(adaInput.value, networkDecimals.value, true);
      let newCoin = isZero(ada.number) ? "0" : getLovelace(ada.whole, ada.fraction);
      if (isMilkomedaTx2.value) {
        if (compare(newCoin, "<", milkomedaMinLovelace2.value)) {
          nextTick(() => {
            validateAdaInput(formatADAString(milkomedaMinLovelace2.value.toString()));
          });
          return false;
        }
      }
      if (output.value.amount.coin !== newCoin) {
        output.value.amount.coin = newCoin;
      }
      const minUtxo = getMinUtxoValue();
      try {
        if (splitOutput()) {
          nextTick(() => {
            onUpdateByOutput(output.value);
          });
          return false;
        }
      } catch (err) {
        $q.notify({
          type: "negative",
          message: (err == null ? void 0 : err.message) ?? "No error message.",
          position: "top-left",
          timeout: 8e3
        });
        nextTick(() => {
          onUpdateByOutput(output.value);
        });
        return false;
      }
      if (output.value.amount.multiasset && isZero(newCoin)) {
        nextTick(() => {
          validateAdaInput(formatADAString(minUtxo));
        });
        return false;
      }
      if (!isZero(newCoin) && compare(newCoin, "<", minUtxo)) {
        nextTick(() => {
          validateAdaInput(formatADAString(minUtxo));
        });
        return false;
      }
      if (adaInputError.value.length === 0) {
        if (isZero(output.value.amount.coin)) {
          return false;
        }
        try {
          await buildSendTx(updateImmediately);
          return true;
        } catch (err) {
          console.error("catch <<<err>>>", err);
        }
      }
      return false;
    };
    const onReset = () => {
      adaInput.value = adaInputDefault;
      adaInputError.value = "";
      adaInputShowInfo.value = false;
      showAssetInput.value.display = false;
      assetToSendList.value = [];
      _lastMissingFee = "";
      if (output.value) {
        clearValueJSON(output.value.amount);
      }
      setTxInvalid();
      adaInputInfo.value = formatADAString(getMinUtxoValue()) + it(props.textId + ".info.default");
      resetSendTx();
      emit("reset");
    };
    const onSubmit = () => {
      if (isValidTxBody.value) {
        emit("submit");
      }
    };
    const resetSendTx = async () => {
      getNewBuildCounter();
      await resetBuiltTx(appAccount2.value, txIndex.value);
      await dispatchSignal(onTxBuiltReset);
      return true;
    };
    const buildSendTx = async (updateImmediately = false) => {
      const counter = getNewBuildCounter();
      if (!updateImmediately) {
        await sleepDefault();
      }
      if (!hasNewerBuild(counter)) {
        let res;
        try {
          res = await dispatchSignal(doJustBuildTxSend, txIndex.value);
        } catch (err) {
          console.log("ERR", err);
        }
        if (hasNewerBuild(counter)) {
          return false;
        }
        if (!res) {
          await dispatchSignal(onTxBuiltError, ErrorBuildTx.missingAccountData, txIndex.value, outputIndex.value);
          return false;
        } else if (res.error) {
          await dispatchSignal(onTxBuiltError, res.error, txIndex.value, outputIndex.value);
          return false;
        }
        await dispatchSignal(onTxBuilt, res, txIndex.value, outputIndex.value);
        return true;
      }
      return false;
    };
    const onUpdateByOutput = (value, oldValue) => {
      var _a;
      if (value) {
        updateAvailableOutputBalance(accountBalances.value, ((_a = appAccount2.value) == null ? void 0 : _a.id) ?? "");
        if (!(value.amount.coin === "0" && adaInput.value === adaInputDefault)) {
          if (value.amount.coin === "0") {
            adaInput.value = adaInputDefault;
          } else {
            adaInput.value = formatADAString(value.amount.coin);
          }
          assetToSendList.value = convertMultiAssetJSONToIAssetSendableList(value.amount.multiasset);
        }
      }
    };
    const _onTxBuilt = (res, _txIndex, _outputIndex) => {
      var _a, _b, _c;
      adaInputError.value = "";
      isHigherThanUsualFee.value = ((_a = res.txConfig) == null ? void 0 : _a.result.isHigherThanUsualFee) ?? false;
      const localTxIndex = txIndex.value;
      const stagingTx2 = getStagingTx(appAccount2.value, localTxIndex);
      const builtTx = getBuiltTx(appAccount2.value, localTxIndex);
      if (stagingTx2 && builtTx) {
        const stagingTxOutput = stagingTx2.body.outputs[_outputIndex];
        const builtTxOutput = builtTx.body.outputs[_outputIndex];
        if (stagingTxOutput && builtTxOutput) {
          if (isEqual(stagingTxOutput.amount.coin, builtTxOutput.amount.coin)) {
            return;
          }
          stagingTxOutput.amount = builtTxOutput.amount;
          adaInput.value = formatADAString(stagingTxOutput.amount.coin);
          dispatchSignalSyncTo((_b = appAccount2.value) == null ? void 0 : _b.id, doUpdateAccountBalances);
          updateAvailableOutputBalance(accountBalances.value, ((_c = appAccount2.value) == null ? void 0 : _c.id) ?? "");
        }
      }
      maxBtnDisabled.value = false;
    };
    let _lastMissingFee = "";
    let _errorToid = -1;
    const _onTxBuiltError = (err, _txIndex, _outputIndex) => {
      var _a;
      maxBtnDisabled.value = false;
      if (isFirstAllPass.value >= 0 && typeof _outputIndex !== "undefined") {
        if (err.startsWith(ErrorBuildTx.couldNotCoverFee)) {
          try {
            const missingFee = abs(err.split(".")[2]);
            if (_lastMissingFee !== missingFee) {
              _lastMissingFee = missingFee;
              onAddAllAda(false, missingFee);
            }
            return;
          } catch (_err) {
            console.error("Could not process missing fee.", err, _err);
          }
        }
      }
      if ((_a = err == null ? void 0 : err.startsWith) == null ? void 0 : _a.call(err, "Value 0 less than")) {
        const ada = valueFromFormattedString(adaInput.value, networkDecimals.value, true);
        if (adaInput.value === adaInputDefault || isZero(ada.number)) {
          adaInputError.value = "Enter a value larger than 0.";
        }
        return;
      }
      const { msg, isWarning } = getTxBuiltErrorMsg(err, _outputIndex, outputIndex, adaSymbol);
      adaInputError.value = msg;
      if (adaInputError.value.length > 0) {
        clearTimeout(_errorToid);
        _errorToid = setTimeout(() => {
          if (adaInputError.value.length > 0) {
            $q.notify({
              type: isWarning ? "warning" : "negative",
              message: adaInputError.value,
              position: "top-left",
              timeout: 8e3
            });
          }
        }, 500);
      }
    };
    const _onTxSignReset = () => {
      if (outputIndex.value === 0) {
        adaInputError.value = "";
        maxBtnDisabled.value = false;
      }
    };
    const splitOutput = () => {
      const epochParams = checkEpochParams(networkId.value);
      if (!epochParams) {
        return false;
      }
      if (!accountData2.value) {
        return false;
      }
      const maxOutputsSize = Math.floor(epochParams.maxTxSize / epochParams.maxValueSize) * epochParams.maxValueSize;
      const _output = output.value;
      if (_output) {
        const _splitOutputList = splitLargeOutput(_output, checkEpochParams(accountData2.value.state.networkId), 0);
        if (_splitOutputList.length > 0) {
          updateValueJSONIfNeeded(_output.amount, _splitOutputList[0].amount);
          _output.cborSize = _splitOutputList[0].cborSize;
          let localTxIndex = txIndex.value;
          let localTx = getStagingTx(appAccount2.value, localTxIndex);
          if (!localTx) throw Error("No tx?");
          for (let i = 1, k = localTx.body.outputs.length; i < _splitOutputList.length; i++, k++) {
            const _splitOutput = _splitOutputList[i];
            _splitOutput.adaHandle = _output.adaHandle;
            _splitOutput.adaHandleAddress = _output.adaHandleAddress;
            _splitOutput.adaHandleAddressNew = _output.adaHandleAddressNew;
            _splitOutput.unstoppabledomain = _output.unstoppabledomain;
            _splitOutput.unstoppabledomainAddress = _output.unstoppabledomainAddress;
            _splitOutput.unstoppabledomainAddressNew = _output.unstoppabledomainAddressNew;
            _splitOutput.milkomedaBridgeAddr = _output.milkomedaBridgeAddr;
            let txEstSize = 0;
            for (const txOutput of localTx.body.outputs) {
              txEstSize += txOutput.cborSize ?? 0;
            }
            if (txEstSize + _splitOutput.cborSize > maxOutputsSize) {
              dispatchSignal(onTxBuiltError, "Could not add all selected tokens to this transaction! (maximum transaction size reached)", txIndex.value, outputIndex.value);
              throw new Error("Transaction too large, choose less tokens.");
            }
            addOutputIndex(appAccount2.value, localTxIndex, k, _splitOutput);
          }
          return true;
        }
      }
      return false;
    };
    const _onAccountSettingsUpdated = (_appAccount) => {
      var _a;
      if (_appAccount.id === ((_a = appAccount2.value) == null ? void 0 : _a.id)) {
        adaInputError.value = "";
        delayedStagingTxUpdate();
      }
    };
    const updateAvailableOutputBalance = (balances, accountId) => {
      const _balances = accountBalances.value;
      if (!output.value) {
        return;
      }
      if (!accountData2.value) {
        return;
      }
      if (accountData2.value.account.id !== accountId) {
        return;
      }
      if (!_balances) {
        return;
      }
      if (balances && _balances.id !== balances.id) {
        return;
      }
      const balance = createIBalance();
      if (accountData2.value.settings.tf.enabled) {
        addToBalance(balance, _balances.lockedAvailableTF);
      } else {
        addToBalance(balance, _balances.lockedAvailable);
      }
      decreaseBalance(balance, _balances.locked);
      if (output.value) {
        addValueToValue(balance, output.value.amount);
      }
      updateBalanceTotal(balance);
      availableOutputBalance.value = balance;
    };
    const delayedStagingTxUpdate = () => {
      nextTick(() => updateStagingTx("", true));
    };
    watch(output, onUpdateByOutput, { immediate: true });
    watch(outputAddress, (value, oldValue) => {
      if (value) {
        adaInputError.value = "";
        delayedStagingTxUpdate();
      } else {
        delayedStagingTxUpdate();
      }
    });
    watch(numOutputs, (value, oldValue) => {
      var _a, _b;
      dispatchSignalSyncTo((_a = appAccount2.value) == null ? void 0 : _a.id, doUpdateAccountBalances);
      updateAvailableOutputBalance(accountBalances.value, ((_b = appAccount2.value) == null ? void 0 : _b.id) ?? "");
      if (value !== oldValue && outputIndex.value === 0) {
        adaInputError.value = "";
        delayedStagingTxUpdate();
      }
    });
    watch(auxData, (value, oldValue) => {
      if (outputIndex.value === 0) {
        adaInputError.value = "";
        delayedStagingTxUpdate();
      }
    }, { deep: true });
    onMounted(() => {
      var _a;
      addSignalListener(onTxBuilt, storeId, _onTxBuilt);
      addSignalListener(onTxBuiltError, storeId, _onTxBuiltError);
      addSignalListener(onTxSignReset, storeId, _onTxSignReset);
      updateAvailableOutputBalance(accountBalances.value, ((_a = appAccount2.value) == null ? void 0 : _a.id) ?? "");
      addSignalListener(onAccountSettingsUpdated, storeId, _onAccountSettingsUpdated);
      addSignalListener(onAccountBalancesUpdated, storeId, updateAvailableOutputBalance);
      addSignalListener(onSelectedUtxoToggled, storeId, delayedStagingTxUpdate);
    });
    onUnmounted(() => {
      removeSignalListener(onTxBuilt, storeId);
      removeSignalListener(onTxBuiltError, storeId);
      removeSignalListener(onTxSignReset, storeId);
      removeSignalListener(onAccountSettingsUpdated, storeId);
      removeSignalListener(onAccountBalancesUpdated, storeId);
      removeSignalListener(onSelectedUtxoToggled, storeId);
    });
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(GridInput, {
          "input-text": adaInput.value,
          class: "col-span-12 xxs:col-span-8",
          "input-c-s-s": "h-8 sm:h-10",
          "input-error": adaInputError.value,
          "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => adaInputError.value = $event),
          "onUpdate:inputText": validateAdaInput,
          onEnter: onSubmit,
          onReset,
          "input-hint": unref(formatADAString)("0"),
          "input-info": adaInputInfo.value,
          "input-text-c-s-s": "text-sm xxs:text-md",
          alwaysShowInfo: adaInputShowInfo.value,
          showReset: !isDonation.value && !__props.disabled,
          "input-disabled": __props.disabled,
          autocomplete: "off",
          "input-id": "inputAda_" + unref(txIndex) + "_" + unref(outputIndex),
          "input-type": "text",
          currency: "",
          "decimal-separator": decimalSeparator.value,
          "group-separator": groupSeparator.value,
          "manual-update": manualUpdate.value
        }, createSlots({
          "icon-prepend": withCtx(() => [
            createBaseVNode("span", _hoisted_1$7, toDisplayString(unref(adaSymbol)), 1)
          ]),
          _: 2
        }, [
          !__props.disabled ? {
            name: "icon-append",
            fn: withCtx(() => [
              unref(isSendAllEnabled) && !isDonation.value ? (openBlock(), createElementBlock("button", {
                key: 0,
                disabled: maxBtnDisabled.value,
                class: "cc-text-semi-bold -mr-0.5 -sm:mr-px ml-1 cc-btn-secondary-inline py-0.5 sm:py-1 px-3 focus:outline-none",
                onClick: _cache[0] || (_cache[0] = withModifiers(($event) => onAddAllAda(true, "0"), ["stop"]))
              }, toDisplayString(unref(it)("common.label.max")), 9, _hoisted_2$6)) : createCommentVNode("", true)
            ]),
            key: "0"
          } : void 0
        ]), 1032, ["input-text", "input-error", "input-hint", "input-info", "alwaysShowInfo", "showReset", "input-disabled", "input-id", "decimal-separator", "group-separator", "manual-update"]),
        isStatic.value && assetToSendList.value.length > 0 ? (openBlock(), createBlock(GridButtonSecondary, {
          key: 0,
          class: "col-span-12 xxs:col-span-4 h-8 sm:h-10",
          label: unref(it)(__props.textId + ".button.token.tokens") + (assetToSendList.value.length > 0 ? " (" + assetToSendList.value.length + ")" : ""),
          link: displayAssetInput
        }, null, 8, ["label"])) : isStatic.value && assetToSendList.value.length === 0 ? (openBlock(), createBlock(GridButtonSecondary, {
          key: 1,
          class: "col-span-12 xxs:col-span-4 h-8 sm:h-10",
          disabled: "",
          label: unref(it)(__props.textId + ".button.token.tokens") + " (0)",
          link: displayAssetInput
        }, null, 8, ["label"])) : !isDonation.value && hasAvailableAssets.value ? (openBlock(), createBlock(GridButtonSecondary, {
          key: 2,
          class: "col-span-12 xxs:col-span-4 h-8 sm:h-10",
          label: unref(it)(__props.textId + ".button.token.addToken") + (assetToSendList.value.length > 0 ? " (" + assetToSendList.value.length + ")" : ""),
          link: displayAssetInput
        }, null, 8, ["label"])) : !isDonation.value ? (openBlock(), createBlock(GridButtonSecondary, {
          key: 3,
          class: "col-span-4 lg:col-span-4 h-8 sm:h-10",
          disabled: "",
          disableTooltip: unref(it)(__props.textId + ".button.token.addTokenHover"),
          label: unref(it)(__props.textId + ".button.token.addToken"),
          link: () => {
          }
        }, null, 8, ["disableTooltip", "label"])) : createCommentVNode("", true),
        isLargeOutput.value ? (openBlock(), createBlock(_sfc_main$r, {
          key: 4,
          text: "Too many tokens on this output.",
          icon: "mdi mdi-alert-octagon-outline",
          html: "",
          dense: "",
          class: "col-span-12",
          "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
          css: "cc-rounded cc-banner-warning overflow-hidden"
        })) : createCommentVNode("", true),
        isHigherThanUsualFee.value ? (openBlock(), createBlock(_sfc_main$r, {
          key: 5,
          text: "The tx fee is higher than necessary, maybe add a few lovelace to one of the outputs.",
          icon: "mdi mdi-alert-octagon-outline",
          html: "",
          dense: "",
          class: "col-span-12",
          "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
          css: "cc-rounded cc-banner-warning overflow-hidden"
        })) : createCommentVNode("", true),
        !__props.disabled ? (openBlock(), createBlock(_sfc_main$9, {
          key: 6,
          title: "Select tokens",
          "show-modal": showAssetInput.value,
          "input-multi-asset": inputMultiAsset.value,
          "is-milkomeda-tx": unref(isMilkomedaTx2),
          "show-selected-asset-list": showSelectedAssetList.value,
          "asset-to-send-list": assetToSendList.value,
          onClose: onAssetUpdateEvent,
          onConfirm: onAssetUpdateEvent,
          onOnAssetUpdateEvent: onAssetUpdateEvent
        }, null, 8, ["show-modal", "input-multi-asset", "is-milkomeda-tx", "show-selected-asset-list", "asset-to-send-list"])) : (openBlock(), createBlock(_sfc_main$9, {
          key: 7,
          title: "Left over tokens of selected UTxO inputs (view only).",
          "show-modal": showAssetInput.value,
          "input-multi-asset": (_a = unref(output)) == null ? void 0 : _a.amount.multiasset,
          "is-milkomeda-tx": unref(isMilkomedaTx2),
          "show-selected-asset-list": showSelectedAssetList.value,
          "asset-to-send-list": assetToSendList.value,
          disabled: ""
        }, null, 8, ["show-modal", "input-multi-asset", "is-milkomeda-tx", "show-selected-asset-list", "asset-to-send-list"]))
      ], 64);
    };
  }
});
const _sfc_main$7 = /* @__PURE__ */ defineComponent({
  __name: "SendOutput",
  props: {
    textId: { type: String, required: true, default: "wallet.send.step.receiveAddr" },
    txIndex: { type: Number, required: true },
    outputIndex: { type: Number, required: true },
    isLastOutput: { type: Boolean, required: false, default: false },
    disabled: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const {
      txIndex,
      outputIndex
    } = toRefs(props);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(SendOutputAddress, {
          "text-id": __props.textId,
          "tx-index": unref(txIndex),
          "output-index": unref(outputIndex),
          disabled: __props.disabled
        }, null, 8, ["text-id", "tx-index", "output-index", "disabled"]),
        createVNode(_sfc_main$8, {
          "text-id": "wallet.send.step.assets",
          "tx-index": unref(txIndex),
          "output-index": unref(outputIndex),
          disabled: __props.disabled
        }, null, 8, ["tx-index", "output-index", "disabled"]),
        __props.isLastOutput ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          class: "mb-2"
        })) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$6 = { class: "cc-grid" };
const _hoisted_2$5 = { class: "relative flex flex-row flex-nowrap justify-between items-center space-x-2" };
const _hoisted_3$5 = { class: "grow min-w-0 flex flex-row flex-nowrap items-start h-5 cc-text-bold" };
const _hoisted_4$4 = {
  key: 0,
  class: "relative cc-flex-fixed flex flex-col flex-nowrap items-start w-6 h-6 -ml-1 -mt-1"
};
const _hoisted_5$2 = { class: "relative flex-grow-0 flex-shrink-0 cursor-pointer cc-text-spacing cc-text-xs hover:cc-text-highlight-hover" };
const _hoisted_6$1 = { class: "ml-5 mr-16 mt-1 break-normal whitespace-pre-wrap" };
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "SendOptionsItem",
  props: {
    label: { type: String, required: true, default: "" },
    caption: { type: String, required: false, default: "" },
    canToggle: { type: Boolean, required: false, default: false },
    canExpand: { type: Boolean, required: false, default: true },
    canCollapse: { type: Boolean, required: false, default: false },
    enabled: { type: Boolean, required: false, default: false },
    separator: { type: Boolean, required: false, default: true },
    headerSeparator: { type: Boolean, required: false, default: false },
    openExpanded: { type: Boolean, required: false, default: false },
    dense: { type: Boolean, required: false, default: false }
  },
  emits: ["toggle"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const open = ref(props.openExpanded);
    const emitToggle = () => {
      emit("toggle");
    };
    const toggleExpand = () => {
      if (!props.canCollapse && open.value) {
        return;
      }
      open.value = props.canExpand ? !open.value : false;
    };
    watch(() => props.openExpanded, (isOpen) => {
      if (isOpen) {
        open.value = true;
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$6, [
        __props.headerSeparator ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          "line-c-s-s": "border-2"
        })) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: normalizeClass(["col-span-12 cc-text-sz flex flex-col flex-nowrap", open.value ? "" : ""])
        }, [
          createBaseVNode("div", {
            class: normalizeClass(__props.canExpand ? "cursor-pointer" : ""),
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => toggleExpand(), ["stop"]))
          }, [
            createBaseVNode("div", _hoisted_2$5, [
              __props.canExpand ? (openBlock(), createBlock(_sfc_main$n, {
                key: 0,
                anchor: "top middle",
                offset: [0, 0],
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(unref(it)("common.label." + (open.value ? "collapse" : "expand"))), 1)
                ]),
                _: 1
              })) : createCommentVNode("", true),
              createBaseVNode("div", _hoisted_3$5, [
                __props.canExpand ? (openBlock(), createElementBlock("div", _hoisted_4$4, [
                  createBaseVNode("i", {
                    class: normalizeClass(["relative text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
                  }, null, 2)
                ])) : createCommentVNode("", true),
                createBaseVNode("span", {
                  class: normalizeClass(["w-full truncate", !__props.canExpand ? "ml-5" : ""])
                }, toDisplayString(__props.label), 3)
              ]),
              createBaseVNode("div", _hoisted_5$2, [
                __props.canToggle ? (openBlock(), createBlock(QToggle_default, {
                  key: 0,
                  class: "relative h-5 -mr-2.5 -ml-2.5",
                  onClick: withModifiers(emitToggle, ["prevent", "stop"]),
                  "model-value": props.enabled
                }, {
                  default: withCtx(() => [
                    createVNode(_sfc_main$n, {
                      anchor: "top middle",
                      offset: [0, 30],
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(__props.canToggle ? "Disable" : "Enable"), 1)
                      ]),
                      _: 1
                    })
                  ]),
                  _: 1
                }, 8, ["model-value"])) : createCommentVNode("", true)
              ])
            ]),
            createBaseVNode("div", _hoisted_6$1, toDisplayString(__props.caption), 1)
          ], 2),
          open.value ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: normalizeClass(["relative w-full grid grid-cols-12", __props.dense ? "cc-gap" : "cc-gap-lg"])
          }, [
            createVNode(GridSpace, { class: "w-full" }),
            renderSlot(_ctx.$slots, "content")
          ], 2)) : createCommentVNode("", true)
        ], 2),
        __props.separator ? (openBlock(), createBlock(GridSpace, {
          key: 1,
          hr: ""
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const parseTxList = async (networkId2, defaultAppAccount, txSubmitType, _txList) => {
  let txList = _txList;
  if (!txList || txList.length === 0) {
    throw ErrorSignTx.missingTx;
  }
  const resList = [];
  const balanceList = [];
  let hintUtxoList = getHintUtxoList(null);
  let totalBalance = null;
  let partialSign = false;
  const txLen = txList.length;
  let appAccount2 = null;
  let allSigned = true;
  const epochParams = checkEpochParams();
  for (let i = 0; i < txLen; i++) {
    const free = [];
    const res = getTransactionFromCbor(networkId2, txList[i].cbor, i, free);
    if (!res.builtTx) {
      throw ErrorSignTx.txCborInvalid;
    }
    for (const cert of res.builtTx.body.certs ?? []) {
      if ((cert.hasOwnProperty("GenesisKeyDelegation") || cert.hasOwnProperty("MoveInstantaneousRewardsCert")) && epochParams.isAtLeastConwayEra) {
        throw ErrorSignTx.deprecatedCertificate;
      }
    }
    res.builtTx.inputUtxoList = hintUtxoList.filter((chained) => res.builtTx.body.inputs.some((input) => input.transaction_id === chained.input.transaction_id && input.index === chained.input.index));
    res.builtTx.inputUtxoList.push(...hintUtxoList.filter((chained) => {
      var _a;
      return !!((_a = res.builtTx.body.collateral) == null ? void 0 : _a.some((input) => input.transaction_id === chained.input.transaction_id && input.index === chained.input.index));
    }));
    await fillInputUtxoList(networkId2, res.builtTx);
    const credList = getSignTxCredList(res);
    allSigned = allSigned && credList.allForeignSigned;
    if (!appAccount2) {
      for (const cred of credList.unsigned) {
        const _appAccount3 = getIAppAccountByCred(cred, true);
        if (_appAccount3) {
          appAccount2 = _appAccount3;
          break;
        }
      }
    }
    const _appAccount2 = appAccount2 ?? defaultAppAccount;
    if (!_appAccount2) {
      throw ErrorSignTx.missingAccountData;
    }
    if (!_appAccount2.data) {
      throw ErrorSignTx.missingAccountData;
    }
    const txBalance = await calcAccountTxBalance(_appAccount2, res.builtTx);
    if (!txBalance) {
      throw ErrorSignTx.txBalanceConversion;
    }
    balanceList.push(txBalance);
    const creds = getSignTxCredList(res, _appAccount2.data);
    res.builtTxBalance = txBalance;
    res.txCredList = creds.allOwnedSigned ? [] : creds.owned;
    res.accountIdList = [_appAccount2.id];
    if (!txList[i].partialSign && !creds.canSignAllUnsigned) {
      throw ErrorSignTx.canOnlySignPartially;
    }
    if (!partialSign && txList[i].partialSign) {
      partialSign = true;
    }
    resList.push(res);
    const outputLen = res.builtTx.body.outputs.length;
    if (txLen > 1) {
      for (let j = 0; j < outputLen; j++) {
        hintUtxoList.push(createIUtxo({
          input: {
            transaction_id: res.txHash,
            index: j
          },
          output: res.builtTx.body.outputs[j]
        }));
      }
    }
  }
  if (!appAccount2 && !allSigned) {
    throw ErrorSignTx.missingAccountData;
  }
  const _appAccount = appAccount2 ?? defaultAppAccount;
  if (txLen > 1) {
    totalBalance = createIBalance();
    for (let i = 0; i < txLen; i++) {
      addToBalance(totalBalance, createIBalance({ coin: balanceList[i].coin, multiasset: balanceList[i].multiasset }), false, i === txLen - 1);
    }
  }
  useSignTx().openSignTx(resList, txSubmitType, balanceList, _appAccount.id, _appAccount.walletId, partialSign, totalBalance, "importTx");
  console.warn("parseTxList: success");
  return { resList, appAccount: _appAccount, allSigned };
};
const _hoisted_1$5 = { class: "cc-grid" };
const _hoisted_2$4 = {
  key: 0,
  class: "relative col-span-12 cc-grid"
};
const _hoisted_3$4 = { class: "col-span-6 lg:col-span-3" };
const textId = "wallet.importTx";
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "SendImport",
  setup(__props) {
    const storeId = "SendImport" + getRandomId();
    const $q = useQuasar();
    const { t } = useTranslation();
    const { appAccount: appAccount2 } = useSelectedAccount();
    const file = ref();
    const uploadedFile = ref();
    const editor = ref("");
    const isLoading = ref(false);
    const importError = ref("");
    function onReset() {
      editor.value = "";
      uploadedFile.value = void 0;
      importError.value = "";
    }
    onErrorCaptured((e) => {
      console.error("Tx Import: onErrorCaptured", e);
      return true;
    });
    watch(editor, () => {
      nextTick(async () => {
        let input = editor.value;
        if (input.length === 0) {
          onReset();
          return;
        }
        const parsed = input.replace(/<[^>]*>/g, "");
        deserializeTx([parsed]);
      });
    });
    async function loadFileContent(file2, processor) {
      const reader = new FileReader();
      const text = new Text();
      reader.addEventListener("load", () => {
        try {
          text.data = reader.result;
          processor(text);
        } catch (error) {
          importError.value = t(textId + ".error.upload");
        }
      }, false);
      reader.readAsDataURL(file2);
    }
    function parseJsonUpload(fileContent) {
      if (fileContent.textContent) {
        let file2 = fileContent.textContent.split(",");
        let formatInfo = file2[0];
        let content = Buffer$1.from(file2[1], "base64").toString();
        console.log("parseJsonUpload", content);
        console.log(formatInfo, formatInfo.includes("application/json"), content.includes("["), content.includes("{"));
        const isHexOnly = !isNaN(parseInt(content, 16));
        if (isHexOnly) {
          deserializeTx([content]);
          return;
        }
        const maybeTxList = JSON.parse(content);
        if (Array.isArray(maybeTxList)) {
          deserializeTx(maybeTxList.map((tx) => tx.cborHex));
        } else {
          deserializeTx([maybeTxList.cborHex]);
        }
      }
    }
    function handleTxFileUpload() {
      if (file.value && file.value.files && file.value.files.length > 0) {
        uploadedFile.value = file.value.files[0];
        loadFileContent(uploadedFile.value, parseJsonUpload);
      } else {
        importError.value = t(textId + ".error.upload");
      }
    }
    function chooseTxFile() {
      importError.value = "";
      const target = document.getElementById("iconFileUpload");
      if (target !== null) {
        target.value = "";
        target.click();
      }
    }
    async function deserializeTx(cbor) {
      try {
        const _appAccount = appAccount2.value;
        if (!_appAccount) {
          throw "No account set";
        }
        await parseTxList(networkId.value, _appAccount, "cc", cbor.map((c) => ({ cbor: c, partialSign: true })));
      } catch (e) {
        $q.notify({
          type: "negative",
          message: getTxImportErrorMsg(e),
          position: "top-left",
          timeout: 8e3
        });
      }
    }
    onMounted(() => {
      addSignalListener(onTxSignCancel, storeId, onReset);
      addSignalListener(onTxSignSubmit, storeId, onReset);
    });
    onUnmounted(() => {
      removeSignalListener(onTxSignCancel, storeId);
      removeSignalListener(onTxSignSubmit, storeId);
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$5, [
        importError.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_2$4, [
          createVNode(_sfc_main$r, {
            text: importError.value,
            icon: "mdi mdi-alert-octagon-outline",
            class: "col-span-12",
            "text-c-s-s": "cc-text-normal text-justify",
            css: "cc-rounded cc-banner-warning items-center"
          }, null, 8, ["text"]),
          createVNode(GridSpace)
        ])) : createCommentVNode("", true),
        createVNode(_sfc_main$k, {
          label: "Tx Cbor / Tx Hash:",
          class: "col-span-12"
        }),
        withDirectives(createBaseVNode("textarea", {
          "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => editor.value = $event),
          class: "col-span-12 cc-bg-light-0 text-xs h-32"
        }, null, 512), [
          [vModelText, editor.value]
        ]),
        createBaseVNode("input", {
          ref_key: "file",
          ref: file,
          class: "hidden",
          id: "iconFileUpload",
          accept: "text/plain, application/json",
          onChange: handleTxFileUpload,
          type: "file"
        }, null, 544),
        createVNode(_sfc_main$w, {
          onClick: chooseTxFile,
          class: "col-span-6 lg:col-span-3",
          label: unref(t)("common.label.selectFile")
        }, null, 8, ["label"]),
        createBaseVNode("div", _hoisted_3$4, [
          createVNode(_sfc_main$y, { active: isLoading.value }, null, 8, ["active"])
        ])
      ]);
    };
  }
});
const _hoisted_1$4 = { class: "col-span-12 grid grid-cols-12 cc-gap xs:cc-p-small" };
const _hoisted_2$3 = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_3$3 = { class: "col-span-12 flex flex-row flex-nowrap cc-text-xs" };
const _hoisted_4$3 = { class: "shrink-0 flex flex-column w-24" };
const _hoisted_5$1 = {
  key: 0,
  class: "italic"
};
const _hoisted_6 = ["selected", "value"];
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "SendMetadataInputRaw",
  props: {
    txIndex: { type: Number, required: true },
    rows: { type: Number, required: false, default: 4 },
    jsonDepth: { type: Number, required: false, default: 0 }
  },
  setup(__props) {
    const props = __props;
    const { txIndex } = toRefs(props);
    const {
      appAccount: appAccount2,
      stagingTx,
      stagingTxConfig,
      addAuxData: addAuxData2
    } = useAppAccountTxLists(txIndex, ref(0));
    const auxData = computed(() => {
      var _a;
      return ((_a = stagingTx.value) == null ? void 0 : _a.auxiliary_data) ?? null;
    });
    const { t } = useTranslation();
    const min_label = "-" + subtract(pow(2, 64), 1);
    const max_label = abs(min_label);
    const metaInput = ref("");
    const metaJson = ref(null);
    const metaInputError = ref("");
    const metaSchema = ref(MetadataJsonSchema.NoConversions);
    const schemaOptions = Object.values(MetadataJsonSchema).filter((v) => isNaN(Number(v)));
    const hasValidMetadata = computed(() => metaJson.value != null && typeof metaJson.value === "object");
    function validateMetaInput(value) {
      var _a;
      metaInputError.value = "";
      metaJson.value = null;
      metaInput.value = value;
      try {
        metaJson.value = JSON.parse(metaInput.value);
      } catch (err) {
        metaInputError.value = t("wallet.send.options.metadata.error.json");
        return;
      }
      try {
        for (const label in metaJson.value) {
          if (label.length === 0) {
            throw "";
          }
          if (compare(label, "<", min_label) || compare(label, ">", max_label)) {
            throw "";
          }
        }
      } catch (err) {
        metaInputError.value = t("wallet.send.options.metadata.error.label");
        return;
      }
      try {
        const metadataList = [];
        for (const entry of Object.entries(metaJson.value)) {
          metadataList.push(createIMetadata({
            label: entry[0],
            metadatum: entry[1]
          }));
        }
        const auxData2 = getMetadataFromJSON(metadataList, metaSchema.value);
        if (auxData2) {
          const auxDataJson = cslToJson(auxData2.to_json());
          safeFreeCSLObject(auxData2);
          addAuxData2(txIndex.value, auxDataJson, true);
          if (stagingTxConfig.value && auxDataJson.metadata && "674" in auxDataJson.metadata) {
            const meta674 = auxDataJson.metadata["674"];
            let validCIP20 = true;
            if ((_a = getMetadataType(meta674)) == null ? void 0 : _a.startsWith("map")) {
              let _json = {};
              createJsonFromCborJson(JSON.parse(meta674), _json, void 0, false);
              if ("msg" in _json && Array.isArray(_json.msg)) {
                for (const line of _json.msg) {
                  if (typeof line !== "string") {
                    validCIP20 = false;
                    break;
                  }
                }
                if (validCIP20) {
                  stagingTxConfig.value.metadata674Lines = _json.msg;
                }
              } else {
                validCIP20 = false;
              }
            } else {
              validCIP20 = false;
            }
            if (!validCIP20) {
              stagingTxConfig.value.metadata674Lines = [];
            }
            dispatchSignal(onTxAuxUpdate);
          }
        }
      } catch (err) {
        metaInputError.value = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
      }
    }
    function onReset() {
      metaInput.value = "";
      metaInputError.value = "";
      if (stagingTxConfig.value) {
        stagingTxConfig.value.metadata674Lines = [];
        dispatchSignal(onTxAuxUpdate);
      }
      addAuxData2(txIndex.value, null, true);
    }
    function onSchemaChange(event) {
      metaSchema.value = event.target.options.selectedIndex;
      if (metaInput.value.length > 0) {
        validateMetaInput(metaInput.value);
      }
    }
    onMounted(() => {
      const txAuxData = auxData.value;
      if (!(txAuxData == null ? void 0 : txAuxData.metadata)) {
        return;
      }
      let _metaInput = {};
      for (const entry of Object.entries(txAuxData.metadata)) {
        if (getMetadataType(entry[1]) === "string" || getMetadataType(entry[1]) === "number") {
          _metaInput[entry[0]] = entry[1];
        } else {
          let _json = {};
          createJsonFromCborJson(JSON.parse(entry[1]), _json, void 0, false);
          _metaInput[entry[0]] = _json;
        }
      }
      metaInput.value = JSON.stringify(_metaInput, null, 2);
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$4, [
        createVNode(GridInput, {
          "input-text": metaInput.value,
          "onUpdate:inputText": [
            _cache[0] || (_cache[0] = ($event) => metaInput.value = $event),
            validateMetaInput
          ],
          "input-error": metaInputError.value,
          "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => metaInputError.value = $event),
          onReset,
          class: "col-span-12",
          "multiline-input": true,
          rows: __props.rows,
          "input-hint": unref(t)("wallet.send.options.metadata.hintJson"),
          alwaysShowInfo: false,
          showReset: true,
          "input-id": "inputMetadata",
          "input-type": "text"
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error", "rows", "input-hint"]),
        createBaseVNode("div", _hoisted_2$3, [
          (openBlock(true), createElementBlock(Fragment, null, renderList(unref(schemaOptions), (schema, index) => {
            return openBlock(), createElementBlock("div", _hoisted_3$3, [
              createBaseVNode("div", _hoisted_4$3, [
                createVNode(_sfc_main$l, {
                  text: schema,
                  class: "cc-text-bold"
                }, null, 8, ["text"]),
                index === 0 ? (openBlock(), createElementBlock("div", _hoisted_5$1, "(recommended)")) : createCommentVNode("", true)
              ]),
              _cache[3] || (_cache[3] = createBaseVNode("span", { class: "mr-1" }, ">", -1)),
              createVNode(_sfc_main$l, {
                text: unref(t)("wallet.send.options.metadata.schemainfo." + schema)
              }, null, 8, ["text"])
            ]);
          }), 256)),
          createBaseVNode("select", {
            class: "col-span-12 xs:col-span-6 cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[2] || (_cache[2] = ($event) => onSchemaChange($event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(schemaOptions), (schema, index) => {
              return openBlock(), createElementBlock("option", {
                key: index,
                selected: index === metaSchema.value,
                value: index
              }, toDisplayString(schema), 9, _hoisted_6);
            }), 128))
          ], 32),
          createVNode(_sfc_main$z, {
            url: "https://developers.cardano.org/docs/get-started/cardano-serialization-lib/transaction-metadata/#json-conversion",
            label: unref(t)("wallet.send.options.metadata.urllabel"),
            "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
            class: "col-span-12"
          }, null, 8, ["label"]),
          hasValidMetadata.value ? (openBlock(), createBlock(unref(S), {
            key: 0,
            class: "col-span-12 font-mono",
            showLength: "",
            showDoubleQuotes: "",
            deep: __props.jsonDepth,
            data: metaJson.value
          }, null, 8, ["deep", "data"])) : createCommentVNode("", true)
        ])
      ]);
    };
  }
});
const _hoisted_1$3 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$2 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$2 = {
  key: 0,
  class: "cc-page-p cc-grid"
};
const _hoisted_4$2 = { class: "col-span-12 flex flex-row justify-start items-center gap-4 mb-2" };
const _hoisted_5 = { class: "col-span-12 flex flex-row justify-start items-center gap-4 mb-2" };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "SendOptions",
  props: {
    open: { type: Boolean, required: true, default: false },
    txIndex: { type: Number, required: true }
  },
  emits: ["close"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const {
      txIndex
    } = toRefs(props);
    const $q = useQuasar();
    const {
      appAccount: appAccount2,
      accountData: accountData2,
      stagingTx,
      builtTx,
      builtTxBalance,
      output,
      resetAllTx: resetAllTx2
    } = useAppAccountTxLists(txIndex, ref(0));
    const { it } = useTranslation();
    const { adaSymbol } = useAdaSymbol();
    const showSpinnerTf = ref(false);
    const showSpinnerCU = ref(false);
    const showMSCU = ref(!isProduction());
    const onClose = () => {
      emit("close");
    };
    const onResetSelected = () => {
      var _a;
      dispatchSignalSyncTo((_a = appAccount2.value) == null ? void 0 : _a.id, doClearSelectedUtxos);
    };
    const doTF = async () => {
      showSpinnerTf.value = true;
      showPositive("Start building token-fragmentation transactions. This may take a while.");
      await sleep(100);
      addSignalListener(onBuiltTxTF, "SendOptions", (res, error) => {
        removeSignalListener(onBuiltTxTF, "SendOptions");
        showSpinnerTf.value = false;
        if (res == null ? void 0 : res.error) {
          let { msg } = getTxBuiltErrorMsg(res ? res.error : { message: "Could not create token-fragmentation transaction." }, 0, { value: 0 }, adaSymbol);
          if (msg.length > 0) {
            if (res.error === ErrorBuildTx.notNecessaryTF) {
              showPositive(msg);
            } else {
              if (msg.startsWith("Too many assets to send")) {
                msg = "Add more ADA or increase TF bundle size and try again. (" + msg + ")";
              }
              showNegative(msg);
            }
          }
          resetAllTx2();
        } else if (error) {
          showNegative(error);
        } else {
          showPositive("Finished creating token-fragmentation transactions. Prepare signing.");
        }
      });
      await dispatchSignal(doBuildTxTF);
      removeSignalListener(onBuiltTxTF, "SendOptions");
      showSpinnerTf.value = false;
    };
    const doCU = async () => {
      const _appAccount = appAccount2.value;
      if (!_appAccount) {
        return;
      }
      showSpinnerCU.value = true;
      try {
        showPositive("Start building collect-utxo transactions. This may take a while.");
        await sleep(100);
        const res = await dispatchSignal(doBuildTxCU);
        if (res.length > 0 && accountData2.value) {
          showPositive("Finished creating collect-utxo transactions. Prepare signing.");
          console.log("IBuiltTxResult[]", res);
          await parseTxSignRequest(_appAccount, "cc", res.map((r) => ({
            cbor: r.txCbor,
            partialSign: false
          })), null);
        } else {
          console.log(res);
          showNegative("Could not create collect-utxo transaction. (1)");
        }
        showSpinnerCU.value = false;
      } catch (err) {
        console.warn(err);
        showSpinnerCU.value = false;
        if (err === ErrorBuildTx.notNecessaryCU) {
          showPositive("No Collect UTxOs necessary.");
        } else {
          showNegative("Could not create collect-utxo transaction.");
        }
      }
    };
    const doMSCU = async (inWallet = false) => {
      const _appAccount = appAccount2.value;
      if (!_appAccount) {
        return;
      }
      showSpinnerCU.value = true;
      try {
        showPositive("Start building collect-utxo transactions. This may take a while.");
        await sleep(100);
        const res = await dispatchSignal(doBuildTxMSCU, inWallet);
        if (res.length > 0 && accountData2.value) {
          showPositive("Finished creating collect-utxo transactions. Prepare signing.");
          await parseTxSignRequest(_appAccount, "cc", res.map((r) => ({
            cbor: r.txCbor,
            partialSign: false
          })), null);
        } else {
          console.log(res);
          showNegative("Could not create collect-utxo transaction. (1)");
        }
        showSpinnerCU.value = false;
      } catch (err) {
        console.warn(err);
        showSpinnerCU.value = false;
        if (err === ErrorBuildTx.notNecessaryCU) {
          showPositive("No Collect UTxOs necessary.");
        } else {
          showNegative("Could not create collect-utxo transaction.");
        }
      }
    };
    const showPositive = (msg, isWarning = false) => {
      $q.notify({
        type: isWarning ? "warning" : "positive",
        message: msg,
        position: "top-left",
        timeout: 1e4
      });
    };
    const showNegative = (msg) => {
      $q.notify({
        type: "negative",
        message: msg,
        position: "top-left",
        timeout: 1e4
      });
    };
    return (_ctx, _cache) => {
      return __props.open ? (openBlock(), createBlock(Modal, {
        key: 0,
        onClose,
        "full-width-on-mobile": ""
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1$3, [
            createBaseVNode("div", _hoisted_2$2, [
              createVNode(_sfc_main$k, {
                label: unref(it)("wallet.send.options.headline")
              }, null, 8, ["label"])
            ])
          ])
        ]),
        content: withCtx(() => [
          unref(appAccount2) ? (openBlock(), createElementBlock("div", _hoisted_3$2, [
            createVNode(_sfc_main$6, {
              class: "col-span-12",
              label: unref(it)("wallet.send.options.tf.label"),
              caption: unref(it)("wallet.send.options.tf.caption"),
              "can-collapse": ""
            }, {
              content: withCtx(() => [
                createBaseVNode("div", _hoisted_4$2, [
                  createVNode(GridButtonSecondary, {
                    class: "px-4 ml-4 h-7 sm:h-10",
                    label: unref(it)("wallet.send.options.tf.label"),
                    link: () => doTF()
                  }, null, 8, ["label", "link"]),
                  showSpinnerTf.value ? (openBlock(), createBlock(QSpinnerDots_default, {
                    key: 0,
                    color: "gray",
                    size: "2em"
                  })) : createCommentVNode("", true)
                ])
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$6, {
              class: "col-span-12",
              label: unref(it)("wallet.send.options.cu.label"),
              caption: unref(it)("wallet.send.options.cu.caption"),
              "can-collapse": ""
            }, {
              content: withCtx(() => [
                createBaseVNode("div", _hoisted_5, [
                  createVNode(GridButtonSecondary, {
                    class: "px-4 ml-4 h-7 sm:h-10",
                    label: unref(it)("wallet.send.options.cu.label"),
                    link: () => doCU()
                  }, null, 8, ["label", "link"]),
                  showMSCU.value ? (openBlock(), createBlock(GridButtonSecondary, {
                    key: 0,
                    class: "px-4 ml-4 h-7 sm:h-10",
                    label: unref(it)("wallet.send.options.ms.label"),
                    link: () => doMSCU()
                  }, null, 8, ["label", "link"])) : createCommentVNode("", true),
                  showMSCU.value ? (openBlock(), createBlock(GridButtonSecondary, {
                    key: 1,
                    class: "px-4 ml-4 h-7 sm:h-10",
                    label: unref(it)("wallet.send.options.ms.label2"),
                    link: () => doMSCU(true)
                  }, null, 8, ["label", "link"])) : createCommentVNode("", true),
                  showSpinnerCU.value ? (openBlock(), createBlock(QSpinnerDots_default, {
                    key: 2,
                    color: "gray",
                    size: "2em"
                  })) : createCommentVNode("", true)
                ])
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$6, {
              class: "col-span-12",
              label: unref(it)("wallet.send.options.metadata.label"),
              caption: unref(it)("wallet.send.options.metadata.caption"),
              "can-collapse": ""
            }, {
              content: withCtx(() => [
                createVNode(_sfc_main$4, {
                  "tx-index": unref(txIndex) ?? 0
                }, null, 8, ["tx-index"])
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$6, {
              class: "col-span-12",
              label: unref(it)("wallet.send.options.is.label"),
              caption: unref(it)("wallet.send.options.is.caption"),
              "can-collapse": ""
            }, {
              content: withCtx(() => [
                createVNode(_sfc_main$A, { "show-select": "" }),
                unref(hasSelectedUtxos)(unref(appAccount2)) ? (openBlock(), createBlock(GridButtonSecondary, {
                  key: 0,
                  class: "col-span-12 xxs:col-span-6 h-7 sm:h-10 mb-2",
                  label: unref(it)("wallet.send.options.is.reset"),
                  link: () => onResetSelected()
                }, null, 8, ["label", "link"])) : createCommentVNode("", true)
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$6, {
              class: "col-span-12",
              label: unref(it)("wallet.send.options.import.label"),
              caption: unref(it)("wallet.send.options.import.caption"),
              "can-collapse": ""
            }, {
              content: withCtx(() => [
                createVNode(_sfc_main$5)
              ]),
              _: 1
            }, 8, ["label", "caption"])
          ])) : createCommentVNode("", true)
        ]),
        _: 1
      })) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$2 = {
  key: 0,
  class: "send-tx cc-grid-sm"
};
const _hoisted_2$1 = {
  key: 0,
  class: "relative col-span-12 -mb-1 cc-text-sz cc-text-semi-bold flex justify-start items-center"
};
const _hoisted_3$1 = {
  key: 2,
  class: "col-span-12"
};
const _hoisted_4$1 = {
  key: 3,
  class: "col-span-12"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "SendTx",
  props: {
    txIndex: { type: Number, required: true },
    allowMessage: { type: Boolean, required: false, default: true }
  },
  setup(__props) {
    const props = __props;
    const {
      txIndex
    } = toRefs(props);
    const {
      appAccount: appAccount2,
      accountData: accountData2,
      stagingTxList: stagingTxList2,
      stagingTx,
      builtTx,
      builtTxBalance,
      output,
      addOutput: addOutput2,
      addDonation: addDonation2,
      removeDonation: removeDonation2
    } = useAppAccountTxLists(txIndex, ref(0));
    const { isAddressOnBlockList } = useGuard();
    const numStagingTx = computed(() => {
      var _a;
      return ((_a = stagingTxList2.value) == null ? void 0 : _a.length) ?? 0;
    });
    const numOutputs = computed(() => {
      var _a;
      return ((_a = stagingTx.value) == null ? void 0 : _a.body.outputs.length) ?? 0;
    });
    const hasDonation = () => {
      var _a;
      if (stagingTx.value) {
        const donationAddr = getDonationAddress(((_a = accountData2.value) == null ? void 0 : _a.state.networkId) ?? "mainnet");
        for (const output2 of stagingTx.value.body.outputs) {
          if (output2.address === donationAddr) {
            return true;
          }
        }
      }
      return false;
    };
    const _hasDonation = ref(hasDonation());
    const isMilkomeda = ref(false);
    const isScam = ref(false);
    const showSendOptions = ref(false);
    const onAddDonation = (add) => {
      if (add) {
        addDonation2(txIndex.value);
      } else {
        removeDonation2(txIndex.value);
      }
      _hasDonation.value = hasDonation();
    };
    const onSendOptions = () => {
      showSendOptions.value = true;
    };
    const onClose = () => {
      showSendOptions.value = false;
    };
    const onAddOutput = () => {
      addOutput2(txIndex.value);
    };
    const onSend = async () => {
      if (builtTx.value) {
        await dispatchSignal(doJustSendBuiltTx, txIndex.value);
      } else {
        console.warn("No transaction was build.");
      }
    };
    const stopWatch = watchEffect(() => {
      if (accountData2.value && stagingTx.value) {
        if (numOutputs.value === 0) {
          onAddOutput();
          nextTick(() => {
            stopWatch();
          });
        }
      }
    });
    watch(numOutputs, () => {
      nextTick(() => {
        _hasDonation.value = hasDonation();
      });
    });
    watchEffect(async () => {
      var _a, _b, _c;
      if ((_a = output.value) == null ? void 0 : _a.milkomedaBridgeAddr) {
        isMilkomeda.value = true;
      } else {
        isMilkomeda.value = false;
      }
      if (((_b = output.value) == null ? void 0 : _b.address) && await isAddressOnBlockList((_c = output.value) == null ? void 0 : _c.address)) {
        isScam.value = true;
      } else {
        isScam.value = false;
      }
    });
    const onResetSelected = () => {
      var _a;
      dispatchSignalSyncTo((_a = appAccount2.value) == null ? void 0 : _a.id, doClearSelectedUtxos);
    };
    onUnmounted(() => {
      onResetSelected();
    });
    onMounted(() => {
      addSignalListener(doResetAllTx, "SendTx", () => {
        nextTick(() => {
          if (accountData2.value && stagingTx.value) {
            if (numOutputs.value === 0) {
              onAddOutput();
            }
          }
        });
      });
    });
    onUnmounted(() => {
      removeSignalListener(doResetAllTx, "SendTx");
    });
    return (_ctx, _cache) => {
      var _a, _b;
      return openBlock(), createElementBlock(Fragment, null, [
        unref(accountData2) && unref(stagingTx) ? (openBlock(), createElementBlock("div", _hoisted_1$2, [
          numStagingTx.value <= 1 ? (openBlock(), createElementBlock("div", _hoisted_2$1, _cache[1] || (_cache[1] = [
            createBaseVNode("span", null, toDisplayString("Send Transaction"), -1)
          ]))) : (openBlock(), createBlock(GridSpace, {
            key: 1,
            class: normalizeClass(["mt-2 sm:mt-5 sm:mb-2 rounded-full overflow-hidden", unref(txIndex) > 0 ? "mt-5 mb-4" : "mt-2 mb-1"]),
            "align-label": "left",
            label: "Transaction " + (unref(txIndex) + 1),
            hr: ""
          }, null, 8, ["class", "label"])),
          (openBlock(true), createElementBlock(Fragment, null, renderList(unref(stagingTx).body.outputs, (output2, outputIndex) => {
            return openBlock(), createBlock(_sfc_main$7, {
              key: "output_" + outputIndex,
              "text-id": "wallet.send.step.receiveAddr",
              "tx-index": unref(txIndex),
              "output-index": outputIndex,
              "is-last-output": outputIndex < numOutputs.value - 1
            }, null, 8, ["tx-index", "output-index", "is-last-output"]);
          }), 128)),
          createVNode(GridSpace, {
            hr: "",
            class: "mt-1 mb-1"
          }),
          unref(builtTx) && unref(builtTxBalance) && unref(accountData2) ? (openBlock(), createElementBlock("div", _hoisted_3$1, [
            createVNode(_sfc_main$B, {
              "tx-balance": unref(builtTxBalance),
              tx: unref(builtTx),
              "account-id": unref(accountData2).account.id,
              "staging-tx": true,
              "is-last-item": "",
              "send-tx": ""
            }, null, 8, ["tx-balance", "tx", "account-id"])
          ])) : createCommentVNode("", true),
          createVNode(GridSpace, {
            hr: "",
            class: "mt-1"
          }),
          !isMilkomeda.value ? (openBlock(), createElementBlock("div", _hoisted_4$1, [
            __props.allowMessage ? (openBlock(), createBlock(_sfc_main$h, {
              key: 0,
              "text-id": "wallet.send.step.metadata",
              "tx-index": unref(txIndex),
              rows: 1
            }, null, 8, ["tx-index"])) : createCommentVNode("", true),
            createVNode(GridSpace, {
              hr: "",
              class: "mt-2 mb-1"
            })
          ])) : createCommentVNode("", true),
          createVNode(GridButtonSecondary, {
            class: "col-span-12 xxs:col-span-6 xl:col-span-3 h-7 sm:h-10",
            label: "Add Recipient",
            link: onAddOutput
          }),
          createVNode(_sfc_main$i, {
            class: "col-span-12 xxs:col-span-6 xl:col-span-3 h-7 sm:h-10",
            label: "Add Donation",
            "has-donation": _hasDonation.value,
            onChecked: _cache[0] || (_cache[0] = ($event) => onAddDonation($event))
          }, null, 8, ["has-donation"]),
          createVNode(GridButtonSecondary, {
            class: "col-span-12 xxs:col-span-6 xl:col-span-3 h-7 sm:h-10",
            label: "Options",
            disabled: !unref(stagingTx),
            link: onSendOptions
          }, null, 8, ["disabled"]),
          isMilkomeda.value || isScam.value ? (openBlock(), createBlock(_sfc_main$C, {
            key: 4,
            class: "col-span-12 xxs:col-span-6 xl:col-span-3 h-7 sm:h-10",
            label: "Send",
            link: onSend,
            disabled: !unref(builtTx) || !(((_a = unref(builtTxBalance)) == null ? void 0 : _a.coin) !== "0"),
            duration: 10
          }, null, 8, ["disabled"])) : (openBlock(), createBlock(GridButtonSecondary, {
            key: 5,
            class: "col-span-12 xxs:col-span-6 xl:col-span-3 h-7 sm:h-10",
            label: "Send",
            disabled: !unref(builtTx) || !unref(builtTx).is_valid || !(((_b = unref(builtTxBalance)) == null ? void 0 : _b.coin) !== "0"),
            link: onSend
          }, null, 8, ["disabled"]))
        ])) : createCommentVNode("", true),
        createVNode(_sfc_main$3, {
          open: showSendOptions.value,
          txIndex: unref(txIndex) ?? 0,
          onClose
        }, null, 8, ["open", "txIndex"])
      ], 64);
    };
  }
});
const _hoisted_1$1 = { class: "relative col-span-12 flex flex-col flex-nowrap md:flex-row-reverse gap-2" };
const _hoisted_2 = { class: "md:sticky top-3 sm:top-4 lg:top-6 grow self-start w-full md:w-80 md:max-w-80 z-20" };
const _hoisted_3 = { class: "cc-grid-sm grow xl:grow-0 xl:w-5xl" };
const _hoisted_4 = { class: "col-span-12" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "Send",
  props: {
    allowMessage: { type: Boolean, required: false, default: true }
  },
  setup(__props) {
    const {
      accountData: accountData2,
      stagingTxList: stagingTxList2,
      resetAllTx: resetAllTx2
    } = useAppAccountTxLists();
    useTranslation();
    onMounted(() => {
      resetAllTx2();
    });
    onUnmounted(() => {
      resetAllTx2();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createBaseVNode("div", _hoisted_2, [
          createVNode(_sfc_main$D, {
            "show-fees": "",
            "always-show-header": ""
          })
        ]),
        createBaseVNode("div", _hoisted_3, [
          createBaseVNode("div", _hoisted_4, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(stagingTxList2), (tx, txIndex) => {
              return openBlock(), createBlock(_sfc_main$2, {
                key: "tx_" + txIndex,
                "tx-index": txIndex,
                "allow-message": __props.allowMessage
              }, null, 8, ["tx-index", "allow-message"]);
            }), 128))
          ])
        ])
      ]);
    };
  }
});
const _hoisted_1 = { class: "cc-page-wallet cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "SendPage",
  setup(__props) {
    const {
      hasSelectedAccount: hasSelectedAccount2,
      hasSelectedWallet: hasSelectedWallet2
    } = useSelectedAccount();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        unref(hasSelectedAccount2) && unref(hasSelectedWallet2) ? (openBlock(), createBlock(_sfc_main$1, { key: 0 })) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as default
};
