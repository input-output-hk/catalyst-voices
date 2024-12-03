import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, e as createBaseVNode, n as normalizeClass, t as toDisplayString, u as unref, F as withDirectives, J as vShow, q as createVNode, a7 as useQuasar, S as reactive, a0 as isMobileApp, eq as hasWebUSB, a as createBlock, h as withCtx, j as createCommentVNode, V as nextTick, dc as purpose, K as networkId, ed as hasWallet } from "./index.js";
import { u as useWalletCreation } from "./useWalletCreation.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { t as trezorDerivationType, a as useTrezorDevice, u as useLedgerDevice } from "./useTrezorDevice.js";
import { _ as _sfc_main$9, u as useKeystoneDevice } from "./Keystone.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$b } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$4, a as _sfc_main$5 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$3 } from "./GridSteps.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./GridRadioGroup.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$6 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { I as IconInfo } from "./IconInfo.js";
import { I as IconError } from "./IconError.js";
import { I as IconWarning } from "./IconWarning.js";
import { _ as _sfc_main$8 } from "./LedgerTransport.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$7 } from "./GridFormAccountSelection.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$a } from "./GridFormWalletName.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useTabId.js";
import "./browser.js";
import "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import "./Modal.js";
import "./_plugin-vue_export-helper.js";
import "./IconCheck.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./GridInput.js";
import "./IconPencil.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./GFEWalletName.vue_vue_type_script_setup_true_lang.js";
import "./GridInputAutocomplete.js";
const _hoisted_1$1 = { class: "col-span-12 flex flex-col" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "TrezorDerivationSelector",
  emits: ["update"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const showDerivationTypeSelection = ref(false);
    const selectedId = ref("trezor");
    const optionsDerivationType = [
      { id: "trezor", label: "Trezor " + it("wallet.pair.setting.trezor.derivation.default"), caption: it("wallet.pair.setting.trezor.derivation.trezor") },
      { id: "icarus", label: "Icarus", caption: it("wallet.pair.setting.trezor.derivation.icarus") },
      { id: "ledger", label: "Ledger", caption: it("wallet.pair.setting.trezor.derivation.ledger") }
    ];
    function onSelectedDerivationType(option) {
      selectedId.value = option.id;
      switch (option.id) {
        case "trezor":
          emit("update", trezorDerivationType.ICARUS_TREZOR);
          console.log(option.id);
          break;
        case "icarus":
          emit("update", trezorDerivationType.ICARUS);
          console.log(option.id);
          break;
        case "ledger":
          emit("update", trezorDerivationType.LEDGER);
          console.log(option.id);
          break;
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createBaseVNode("div", {
          class: "flex flex-row flex-nowrap items-center whitespace-pre-wrap cursor-pointer",
          onClick: _cache[0] || (_cache[0] = ($event) => showDerivationTypeSelection.value = !showDerivationTypeSelection.value)
        }, [
          createBaseVNode("i", {
            class: normalizeClass(["cc-text-md mr-2", showDerivationTypeSelection.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
          }, null, 2),
          createBaseVNode("span", null, toDisplayString(unref(it)("wallet.pair.setting.trezor.label")), 1)
        ]),
        withDirectives(createVNode(_sfc_main$2, {
          class: "mt-2",
          id: "trezor_derivation_type",
          name: "trezor_derivation_type",
          options: optionsDerivationType,
          "default-id": selectedId.value,
          onSelected: onSelectedDerivationType
        }, null, 8, ["default-id"]), [
          [vShow, showDerivationTypeSelection.value]
        ])
      ]);
    };
  }
});
const _hoisted_1 = { class: "min-h-16 sm:min-h-20 w-full max-w-full p-3 text-center flex flex-col flex-nowrap justify-center items-center border-t border-b mb-px cc-text-sz cc-bg-white-0" };
const _hoisted_2 = { class: "cc-text-semi-bold" };
const _hoisted_3 = { class: "" };
const _hoisted_4 = { class: "cc-page-wallet cc-text-sz" };
const _hoisted_5 = { class: "col-span-12 flex flex-row flex-nowrap" };
const _hoisted_6 = {
  key: 1,
  class: "col-span-12 flex flex-row flex-nowrap items-center"
};
const _hoisted_7 = {
  key: 2,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_8 = {
  key: 4,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_9 = {
  key: 5,
  class: "col-span-12 flex flex-row flex-nowrap items-center whitespace-pre-wrap cc-text-sz"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Pair",
  setup(__props) {
    const { it } = useTranslation();
    const {
      gotoWalletList,
      openWallet
    } = useNavigation();
    const {
      setWalletName,
      setAccountPubBech32List,
      generateWalletIdFromPubBech32,
      createWallet
    } = useWalletCreation();
    const {
      initiateTrezor,
      getTrezorPublicKey
    } = useTrezorDevice();
    const {
      getLedgerPublicKeyAndSerial
    } = useLedgerDevice();
    const {
      getKeystonePublicKeyUR,
      handleMultiAccountScan
    } = useKeystoneDevice();
    const $q = useQuasar();
    const currentStep = ref(0);
    const selectedOptionHWType = ref(null);
    const selectedTrezorDT = ref();
    const connectError = ref("");
    const deviceName = ref("");
    const walletIdSuffix = ref();
    const masterFingerprint = ref();
    const numAccounts = ref(1);
    const keystoneUR = ref();
    function resetInputs() {
      connectError.value = "";
      deviceName.value = "";
      walletIdSuffix.value = void 0;
      masterFingerprint.value = void 0;
      setWalletName("");
      setAccountPubBech32List([]);
    }
    resetInputs();
    function goBack() {
      if (currentStep.value === 1) {
        currentStep.value = 0;
      } else if (currentStep.value === 2) {
        currentStep.value = 1;
        resetInputs();
      } else if (currentStep.value === 3) {
        currentStep.value = 2;
        resetInputs();
      }
    }
    function gotoNextStepConnectHWDevice(payload) {
      numAccounts.value = payload.accountNumber;
      currentStep.value = 2;
      if (selectedOptionHWType.value.id === "keystone") {
        nextTick(() => {
          gotoNextStepWalletName();
        });
      }
    }
    ref();
    async function gotoNextStepWalletName() {
      if (selectedOptionHWType.value === null) {
        return;
      }
      connectError.value = "";
      const device = selectedOptionHWType.value.id;
      if (device === "ledger" || device === "trezor") {
        $q.loading.show({
          boxClass: "cc-bg-overlay",
          message: it("wallet.pair.step.connect.loading." + selectedOptionHWType.value.id),
          html: true
        });
      }
      if (selectedOptionHWType.value.id === "ledger") {
        try {
          const {
            serial,
            pubKeyList
          } = await getLedgerPublicKeyAndSerial(purpose.hdwallet, -1, numAccounts.value);
          deviceName.value = "Ledger-" + serial;
          setWalletName(deviceName.value);
          setAccountPubBech32List(pubKeyList);
        } catch (err) {
          connectError.value = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
        }
      } else if (selectedOptionHWType.value.id === "trezor") {
        try {
          const features = await initiateTrezor();
          const pubKeyList = await getTrezorPublicKey(purpose.hdwallet, 0, numAccounts.value, [], selectedTrezorDT.value ?? trezorDerivationType.ICARUS_TREZOR);
          deviceName.value = "Trezor-" + (features.label ?? "");
          switch (selectedTrezorDT.value) {
            case trezorDerivationType.ICARUS_TREZOR:
              walletIdSuffix.value = "t";
              break;
            case trezorDerivationType.ICARUS:
              walletIdSuffix.value = "i";
              break;
            case trezorDerivationType.LEDGER:
              walletIdSuffix.value = "l";
              break;
            default:
              walletIdSuffix.value = "t";
          }
          setWalletName(deviceName.value);
          setAccountPubBech32List(pubKeyList);
        } catch (err) {
          connectError.value = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
        }
      } else if (selectedOptionHWType.value.id === "keystone") {
        try {
          const ur = getKeystonePublicKeyUR(purpose.hdwallet, -1, numAccounts.value);
          const res = await signWithKeystone(ur);
          if (res.error) {
            throw Error(res.error);
          }
          deviceName.value = "Keystone-" + (res.id ?? "");
          masterFingerprint.value = res.id ?? "";
          setWalletName(deviceName.value);
          setAccountPubBech32List(res.pubKeyList ?? []);
        } catch (err) {
          connectError.value = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
        }
      }
      $q.loading.hide();
      generateWallet();
    }
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
          keystoneSignResolve(handleMultiAccountScan(data.type, data.cbor));
        }
      } catch (err) {
        if (keystoneSignResolve) {
          keystoneSignResolve({ error: (err == null ? void 0 : err.message) ?? JSON.stringify(err) });
        }
      }
      keystoneUR.value = void 0;
    }
    function generateWallet() {
      if (!connectError.value) {
        try {
          const walletId = generateWalletIdFromPubBech32(networkId.value, selectedOptionHWType.value.id, walletIdSuffix.value);
          if (hasWallet(walletId)) {
            $q.notify({
              type: "warning",
              message: it("wallet.pair.message.duplicate"),
              position: "top-left"
            });
            openWallet(walletId);
          } else {
            currentStep.value = 3;
          }
        } catch (err) {
          connectError.value = err.message;
        }
      }
    }
    async function gotoNextStepWalletCreation(payload) {
      if (selectedOptionHWType.value === null) {
        return;
      }
      deviceName.value = payload.walletName;
      setWalletName(payload.walletName);
      try {
        if (!networkId.value) {
          throw new Error("Error: No active network.");
        }
        const walletId = await createWallet(networkId.value, selectedOptionHWType.value.id, numAccounts.value, walletIdSuffix.value, masterFingerprint.value);
        $q.notify({
          type: "positive",
          message: it("wallet.pair.message.success"),
          position: "top-left"
        });
        openWallet(walletId);
      } catch (err) {
        const errorMessage = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
        $q.notify({
          type: "negative",
          message: errorMessage,
          position: "top-left",
          timeout: 8e3
        });
        gotoWalletList();
        console.error("CreateWallet: Error:", err.errorMessage);
      }
    }
    function onSelectedHWType(option) {
      selectedOptionHWType.value = option;
    }
    function onTrezorDerivationTypeUpdate(derivationType) {
      selectedTrezorDT.value = derivationType;
    }
    function gotoNextStepAccountSelection() {
      if (selectedOptionHWType.value !== null) {
        connectError.value = "";
        currentStep.value = 1;
      }
    }
    const optionsSteps = reactive([
      { id: "type", label: it("wallet.pair.step.type.label") },
      { id: "account", label: it("wallet.restore.step.account.label") },
      { id: "connect", label: it("wallet.pair.step.connect.label") },
      { id: "name", label: it("wallet.pair.step.name.label") }
    ]);
    const optionsHWtype = reactive([]);
    optionsHWtype.push({ id: "keystone", label: it("wallet.pair.step.type.option.keystone.label"), caption: it("wallet.pair.step.type.option.keystone.caption"), icon: "/images/keystone-64.png" });
    if (!isMobileApp() && hasWebUSB()) {
      optionsHWtype.push({ id: "ledger", label: it("wallet.pair.step.type.option.ledger.label"), caption: it("wallet.pair.step.type.option.ledger.caption"), icon: "/images/ledger-64.png" });
      optionsHWtype.push({ id: "trezor", label: it("wallet.pair.step.type.option.trezor.label"), caption: it("wallet.pair.step.type.option.trezor.caption"), icon: "/images/trezor-64.png" });
    }
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$b, {
        containerCSS: "",
        "align-top": ""
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("span", _hoisted_2, toDisplayString(unref(it)("wallet.pair.headline")), 1),
            createBaseVNode("span", _hoisted_3, toDisplayString(unref(it)("wallet.pair.caption")), 1)
          ])
        ]),
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_4, [
            createVNode(_sfc_main$3, {
              onBack: goBack,
              steps: optionsSteps,
              currentStep: currentStep.value,
              "small-c-s-s": "pr-20 xs:pr-20 lg:pr-24"
            }, {
              step0: withCtx(() => {
                var _a;
                return [
                  createVNode(_sfc_main$4, {
                    label: unref(it)("wallet.pair.step.type.headline"),
                    class: ""
                  }, null, 8, ["label"]),
                  createVNode(_sfc_main$5, {
                    text: unref(it)("wallet.pair.step.type.caption"),
                    class: "cc-text-sz"
                  }, null, 8, ["text"]),
                  createVNode(GridSpace, {
                    hr: "",
                    class: "my-0.5 sm:my-2"
                  }),
                  createVNode(_sfc_main$2, {
                    id: "hw_wallet_pairing",
                    name: "hw_wallet_pairing",
                    deselectable: "",
                    options: optionsHWtype,
                    "default-id": (_a = selectedOptionHWType.value) == null ? void 0 : _a.id,
                    onSelected: onSelectedHWType
                  }, null, 8, ["options", "default-id"]),
                  createVNode(_sfc_main$6, {
                    class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3",
                    label: unref(it)("wallet.pair.step.type.button.next"),
                    link: gotoNextStepAccountSelection,
                    disabled: selectedOptionHWType.value === null
                  }, null, 8, ["label", "disabled"])
                ];
              }),
              step1: withCtx(() => [
                createVNode(_sfc_main$7, {
                  onSubmit: gotoNextStepConnectHWDevice,
                  class: "col-span-12",
                  "text-id": "wallet.restore.step.password"
                }, {
                  btnBack: withCtx(() => [
                    createVNode(GridButtonSecondary, {
                      label: "Back",
                      link: goBack,
                      class: "col-start-0 col-span-12 lg:col-start-0 lg:col-span-3"
                    })
                  ]),
                  _: 1
                })
              ]),
              step2: withCtx(() => {
                var _a, _b, _c, _d, _e, _f, _g;
                return [
                  createVNode(_sfc_main$4, {
                    label: unref(it)("wallet.pair.step.connect.headline"),
                    class: ""
                  }, null, 8, ["label"]),
                  createBaseVNode("div", _hoisted_5, [
                    createVNode(IconInfo, { class: "w-7 flex-none mr-2" }),
                    createVNode(_sfc_main$5, {
                      text: unref(it)("wallet.pair.step.connect.caption." + ((_a = selectedOptionHWType.value) == null ? void 0 : _a.id)),
                      class: "cc-text-sz"
                    }, null, 8, ["text"])
                  ]),
                  unref(it)("wallet.pair.step.connect.notice." + ((_b = selectedOptionHWType.value) == null ? void 0 : _b.id)).length !== 0 ? (openBlock(), createBlock(GridSpace, {
                    key: 0,
                    hr: "",
                    class: "my-2"
                  })) : createCommentVNode("", true),
                  unref(it)("wallet.pair.step.connect.notice." + ((_c = selectedOptionHWType.value) == null ? void 0 : _c.id)).length !== 0 ? (openBlock(), createElementBlock("div", _hoisted_6, [
                    createVNode(IconWarning, { class: "w-7 flex-none mr-2" }),
                    createVNode(_sfc_main$5, {
                      text: unref(it)("wallet.pair.step.connect.notice." + ((_d = selectedOptionHWType.value) == null ? void 0 : _d.id)),
                      class: "cc-text-sz"
                    }, null, 8, ["text"])
                  ])) : createCommentVNode("", true),
                  createVNode(GridSpace, {
                    hr: "",
                    class: "mt-2"
                  }),
                  ((_e = selectedOptionHWType.value) == null ? void 0 : _e.id) === "ledger" ? (openBlock(), createElementBlock("div", _hoisted_7, [
                    createVNode(_sfc_main$8),
                    createVNode(GridSpace, {
                      hr: "",
                      class: "mb-2"
                    })
                  ])) : createCommentVNode("", true),
                  ((_f = selectedOptionHWType.value) == null ? void 0 : _f.id) === "keystone" ? (openBlock(), createBlock(_sfc_main$9, {
                    key: 3,
                    open: !!keystoneUR.value,
                    "keystone-u-r": keystoneUR.value,
                    onClose: onKeystoneClose,
                    onDecode: onKeystoneScan
                  }, null, 8, ["open", "keystone-u-r"])) : ((_g = selectedOptionHWType.value) == null ? void 0 : _g.id) === "trezor" ? (openBlock(), createElementBlock("div", _hoisted_8, [
                    createVNode(_sfc_main$1, { onUpdate: onTrezorDerivationTypeUpdate }),
                    createVNode(GridSpace, {
                      hr: "",
                      class: "mb-2"
                    })
                  ])) : createCommentVNode("", true),
                  connectError.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_9, [
                    createVNode(IconError, { class: "w-7 flex-none mr-2" }),
                    createVNode(_sfc_main$5, { text: connectError.value }, null, 8, ["text"])
                  ])) : createCommentVNode("", true),
                  connectError.value.length > 0 ? (openBlock(), createBlock(GridSpace, {
                    key: 6,
                    hr: ""
                  })) : createCommentVNode("", true),
                  createVNode(GridSpace, { dense: "" }),
                  createVNode(GridButtonSecondary, {
                    class: "col-start-0 col-span-6 lg:col-start-7 lg:col-span-3",
                    label: unref(it)("wallet.pair.step.connect.button.back"),
                    link: goBack
                  }, null, 8, ["label"]),
                  createVNode(_sfc_main$6, {
                    class: "col-span-6 lg:col-span-3",
                    label: unref(it)("wallet.pair.step.connect.button.next"),
                    link: gotoNextStepWalletName
                  }, null, 8, ["label"])
                ];
              }),
              step3: withCtx(() => [
                createVNode(_sfc_main$a, {
                  class: "col-span-12",
                  "text-id": "wallet.pair.step.name",
                  "prefilled-wallet-name": deviceName.value,
                  "is-update": false,
                  onSubmit: gotoNextStepWalletCreation
                }, {
                  btnBack: withCtx(() => [
                    createVNode(GridButtonSecondary, {
                      class: "col-start-0 col-span-12 lg:col-start-0 lg:col-span-3",
                      label: unref(it)("wallet.pair.step.name.button.back"),
                      link: goBack
                    }, null, 8, ["label"])
                  ]),
                  _: 1
                }, 8, ["prefilled-wallet-name"])
              ]),
              _: 1
            }, 8, ["steps", "currentStep"])
          ])
        ]),
        _: 1
      });
    };
  }
});
export {
  _sfc_main as default
};
