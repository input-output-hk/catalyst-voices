const __vite__mapDeps=(i,m=__vite__mapDeps,d=(m.f||(m.f=["ui/useDownload2.js","ui/index.js","ui/NetworkId.js","assets/index.css","ui/index2.js"])))=>i.map(i=>d[i]);
import { d as defineComponent, a7 as useQuasar, z as ref, gY as createIUIBackground, f as computed, w as watchEffect, C as onMounted, aG as onUnmounted, o as openBlock, a as createBlock, h as withCtx, e as createBaseVNode, q as createVNode, u as unref, t as toDisplayString, b as withModifiers, j as createCommentVNode, $ as isBexApp, K as networkId, gZ as encodeHex, c as createElementBlock, a2 as now, aE as createWalletDownloadable, ae as useSelectedAccount, H as Fragment, k as dispatchSignalSync, g_ as doFullWalletResync, fM as dispatchSignalSyncTo, g$ as doFullAccountResync, aV as useRoute, D as watch, S as reactive, aA as renderSlot, h0 as getVkFromXpub, h1 as getXvkFromXpub, V as nextTick, F as withDirectives, J as vShow, i as createTextVNode, a_ as decryptText, dc as purpose, a0 as isMobileApp, eC as __vitePreload, fr as isValidSendAddress, h2 as getAddressType, h3 as minCollateral, h4 as maxCollateral, I as renderList, n as normalizeClass, B as useFormatter, aW as addSignalListener, aX as removeSignalListener, h5 as onBuiltTxCollateral, g3 as getTxBuiltErrorMsg, f_ as ErrorBuildTx, bm as dispatchSignal, h6 as doBuildTxCollateral, h7 as getOwnedCredFromAddrBech32, h8 as getDerivationPath, c3 as isZero, eW as compare, h9 as onBuiltTxDeregistration, ha as doBuildTxDeregistration, hb as onBuiltTxDRepDeregistration, hc as doBuildTxDRepDeregistration, hd as ReportingAccountType, aQ as onNetworkFeaturesUpdated, cf as getRandomId, aO as deleteWallet, he as loadWalletList } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { a as _sfc_main$l, _ as _sfc_main$m } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { I as IconPencil } from "./IconPencil.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$j } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { r as removeBackground, a as setSiteOpacity, s as setWalletBackground, g as getBackgroundData, b as addBackgroundIFrame, c as setBackground } from "./ExtBackground.js";
import { L as LZString } from "./lz-string.js";
import { r as resizeImageFile } from "./image.js";
import { _ as _sfc_main$k } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$n } from "./GridFormWalletName.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$o } from "./GridFormPasswordReset.vue_vue_type_script_setup_true_lang.js";
import { u as useDownload } from "./useDownload.js";
import { _ as _sfc_main$p } from "./SettingsItem.vue_vue_type_script_setup_true_lang.js";
import { e as isStakingEnabled } from "./NetworkId.js";
import { b as browser } from "./browser.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$r } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$q } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { u as useLedgerDevice, a as useTrezorDevice } from "./useTrezorDevice.js";
import { _ as _sfc_main$s, u as useKeystoneDevice } from "./Keystone.vue_vue_type_script_setup_true_lang.js";
import { u as useBalanceVisible } from "./useBalanceVisible.js";
import { _ as _sfc_main$v } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$u } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$t } from "./AccessPasswordInputModal.vue_vue_type_script_setup_true_lang.js";
import { G as GridInputAutocomplete } from "./GridInputAutocomplete.js";
import { _ as _sfc_main$w } from "./ScanQrCode.vue_vue_type_script_setup_true_lang.js";
import { p as processFile } from "./scanner.js";
import { u as useAdaSymbol } from "./useAdaSymbol.js";
import { _ as _sfc_main$x } from "./GridAccountUtxoItem.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$z } from "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$y } from "./GridToggle.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1$e = { class: "col-span-12 col-start-0 grid grid-cols-12" };
const _hoisted_2$a = { class: "col-span-full" };
const _hoisted_3$9 = { class: "grid grid-cols-12" };
const _hoisted_4$8 = { class: "col-span-full flex pb-2" };
const _hoisted_5$5 = { class: "col-span-full flex" };
const _hoisted_6$2 = { class: "col-span-full grid grid-cols-12 pt-3" };
const _hoisted_7$2 = { class: "col-span-12 flex flex-col flex-nowrap space-y-2 justify-between items-start" };
const _hoisted_8$2 = { class: "w-full cc-px flex flex-row flex-nowrap justify-between items-start" };
const _hoisted_9$1 = { class: "cc-text-bold" };
const _hoisted_10$1 = { class: "col-span-12 flex pt-2" };
const mezPolicy = "6cf6b5cf0fefbe9e69d640d8be84912bb2c9e132671954548790bcfb";
const mezMax = 9999;
const minOpacity = 60;
const maxOpacity = 100;
const opacitySteps = 0.1;
const _sfc_main$i = /* @__PURE__ */ defineComponent({
  __name: "GridFormWalletBackground",
  props: {
    textId: { type: String, required: false, default: "" },
    prefilledWalletName: { type: String, required: false, default: "" },
    prefilledGroupName: { type: String, required: false, default: "" },
    isUpdate: { type: Boolean, required: false, default: false },
    saving: { type: Boolean, required: false, default: false },
    inputCSS: { type: String, default: "cc-input" },
    backgroundData: { type: Object, required: false }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const props = __props;
    const { it } = useTranslation();
    const $q = useQuasar();
    const tokenPolicyIdValue = ref("");
    const tokenNameValue = ref("");
    const bgOpacity = ref();
    const siteOpacity = ref(100);
    const previewSetting = ref(createIUIBackground());
    const submitEnabled = ref(false);
    const inputDataEqualsSavedData = computed(() => {
      var _a;
      return tokenPolicyIdValue.value == ((_a = props.backgroundData) == null ? void 0 : _a.policy) && tokenNameValue.value == props.backgroundData.name;
    });
    const getOpacityValue = () => {
      var _a;
      return ((_a = bgOpacity.value) == null ? void 0 : _a.value) ? parseInt(bgOpacity.value.value) : maxOpacity;
    };
    const getRandomInt = (max) => Math.floor(Math.random() * max).toString();
    const showPreviewButton = computed(() => {
      return !inputDataEqualsSavedData.value && tokenPolicyIdValue.value && tokenNameValue.value && isValidOpacity() && !previewSetting.value.policy;
    });
    const showClearPreviewButton = computed(() => {
      return previewSetting.value.policy && !inputDataEqualsSavedData.value;
    });
    const showClearBackgroundButton = computed(() => {
      var _a;
      return ((_a = props.backgroundData) == null ? void 0 : _a.policy) != "";
    });
    const changeOpacity = () => {
      if (bgOpacity.value) {
        setSiteOpacity(parseInt(bgOpacity.value.value));
        submitEnabled.value = true;
      }
    };
    watchEffect(() => {
      var _a;
      submitEnabled.value = getOpacityValue() !== ((_a = props.backgroundData) == null ? void 0 : _a.opacity);
    });
    const clearPreview = () => {
      previewSetting.value.policy = "";
      previewSetting.value.name = "";
      previewSetting.value.opacity = siteOpacity.value;
      removeBackground();
      setSiteOpacity(maxOpacity);
      setSavedWalletBackground();
      setWalletBackground(networkId.value, props.backgroundData ?? null);
    };
    const isValidOpacity = () => {
      var _a, _b, _c;
      return ((_a = bgOpacity.value) == null ? void 0 : _a.value) != null && Number((_b = bgOpacity.value) == null ? void 0 : _b.value) >= minOpacity && Number((_c = bgOpacity.value) == null ? void 0 : _c.value) <= maxOpacity;
    };
    const setSavedWalletBackground = () => {
      var _a, _b, _c, _d;
      if (((_a = props.backgroundData) == null ? void 0 : _a.policy) != "") {
        tokenPolicyIdValue.value = ((_b = props.backgroundData) == null ? void 0 : _b.policy) ?? "";
        tokenNameValue.value = ((_c = props.backgroundData) == null ? void 0 : _c.name) ?? "";
        bgOpacity.value.value = (((_d = props.backgroundData) == null ? void 0 : _d.opacity) ?? maxOpacity).toString();
      }
    };
    const randomMez = async () => {
      tokenPolicyIdValue.value = mezPolicy;
      let randomInt = getRandomInt(mezMax);
      while (randomInt.length < 4) {
        randomInt = "0" + randomInt;
      }
      tokenNameValue.value = encodeHex("mesmerizer0" + randomInt);
      submitEnabled.value = true;
    };
    const removeCurrentBackground = () => {
      tokenPolicyIdValue.value = "";
      tokenNameValue.value = "";
      removeBackground();
      setSiteOpacity(maxOpacity);
      emit("submit", {
        policy: "",
        name: "",
        opacity: maxOpacity
      });
      submitEnabled.value = false;
    };
    const testBackground = async () => {
      const policy = tokenPolicyIdValue.value ?? "";
      const name = tokenNameValue.value ?? "";
      const opacity = getOpacityValue();
      try {
        let backgroundData = await getBackgroundData(
          networkId.value,
          createIUIBackground(
            {
              policy,
              name,
              opacity
            }
          )
        );
        if (backgroundData) {
          addBackgroundIFrame();
          try {
            setBackground(backgroundData);
            setSiteOpacity(getOpacityValue());
            previewSetting.value.policy = tokenPolicyIdValue.value;
            previewSetting.value.name = tokenNameValue.value;
            previewSetting.value.opacity = parseInt(bgOpacity.value.value);
          } catch (err) {
            $q.notify({
              type: "negative",
              message: it("wallet.background.error.bexMode"),
              position: "top",
              timeout: 1e4
            });
          }
        } else {
          $q.notify({
            type: "negative",
            message: it("wallet.background.error.metadata"),
            position: "top",
            timeout: 1e4
          });
        }
      } catch (error) {
        $q.notify({
          type: "negative",
          message: it("wallet.background.error.metadata"),
          position: "top",
          timeout: 1e4
        });
      }
    };
    const onSubmit = async () => {
      const policy = tokenPolicyIdValue.value ?? "";
      const name = tokenNameValue.value ?? "";
      const opacity = getOpacityValue();
      if (!policy) {
        removeBackground();
        setSiteOpacity(maxOpacity);
      } else {
        if (policy !== previewSetting.value.policy || name !== previewSetting.value.name) {
          await testBackground();
        } else if (opacity !== previewSetting.value.opacity) {
          setSiteOpacity(opacity);
        }
      }
      previewSetting.value.policy = "";
      previewSetting.value.name = "";
      previewSetting.value.opacity = 100;
      emit("submit", { policy, name, opacity });
    };
    const onReset = () => {
      var _a, _b, _c;
      tokenPolicyIdValue.value = ((_a = props.backgroundData) == null ? void 0 : _a.policy) ?? "";
      tokenNameValue.value = ((_b = props.backgroundData) == null ? void 0 : _b.name) ?? "";
      bgOpacity.value.value = (((_c = props.backgroundData) == null ? void 0 : _c.opacity) ?? "0").toString();
      if (previewSetting.value.policy != "") {
        previewSetting.value.policy = "";
        previewSetting.value.name = "";
        previewSetting.value.opacity = 100;
        removeBackground();
        setWalletBackground(networkId.value, props.backgroundData ?? null);
        setSiteOpacity(maxOpacity);
      }
    };
    onMounted(() => {
      var _a, _b, _c, _d, _e;
      if (((_b = (_a = props.backgroundData) == null ? void 0 : _a.policy) == null ? void 0 : _b.length) ?? 0 > 0) {
        tokenPolicyIdValue.value = ((_c = props.backgroundData) == null ? void 0 : _c.policy) ?? "";
        tokenNameValue.value = ((_d = props.backgroundData) == null ? void 0 : _d.name) ?? "";
        bgOpacity.value.value = (((_e = props.backgroundData) == null ? void 0 : _e.opacity) ?? maxOpacity).toString();
      }
    });
    onUnmounted(() => {
      if (previewSetting.value.policy != "") {
        removeBackground();
        setSiteOpacity(maxOpacity);
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$j, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": __props.textId + ".walletname",
        "reset-button-label": unref(it)(__props.textId + ".button.reset"),
        "submit-button-label": unref(it)(__props.textId + ".button.save"),
        "submit-disabled": !submitEnabled.value || __props.saving,
        "reset-disabled": __props.saving
      }, {
        btnBack: withCtx(() => [
          createBaseVNode("div", _hoisted_1$e, [
            createBaseVNode("div", _hoisted_2$a, [
              createBaseVNode("div", _hoisted_3$9, [
                createBaseVNode("div", _hoisted_4$8, [
                  createVNode(GridInput, {
                    "input-text": tokenPolicyIdValue.value,
                    "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => tokenPolicyIdValue.value = $event),
                    label: unref(it)("wallet.background.tokenPolicy.label"),
                    class: "",
                    showReset: false,
                    "input-id": "inputBackgroundPolicyId",
                    "input-type": "text",
                    autocomplete: "policy"
                  }, {
                    "icon-prepend": withCtx(() => [
                      createVNode(IconPencil, { class: "h-5 w-5" })
                    ]),
                    _: 1
                  }, 8, ["input-text", "label"])
                ]),
                createBaseVNode("div", _hoisted_5$5, [
                  createVNode(GridInput, {
                    "input-text": tokenNameValue.value,
                    "onUpdate:inputText": _cache[1] || (_cache[1] = ($event) => tokenNameValue.value = $event),
                    label: unref(it)("wallet.background.assetName.label"),
                    "input-info": unref(it)("wallet.background.assetName.info"),
                    class: "col-start-4 col-span-9",
                    showReset: false,
                    "input-id": "inputBackgroundTokenName",
                    "input-type": "text",
                    autocomplete: "tokenName"
                  }, {
                    "icon-prepend": withCtx(() => [
                      createVNode(IconPencil, { class: "h-5 w-5" })
                    ]),
                    _: 1
                  }, 8, ["input-text", "label", "input-info"])
                ]),
                createBaseVNode("div", _hoisted_6$2, [
                  createBaseVNode("div", _hoisted_7$2, [
                    createBaseVNode("div", _hoisted_8$2, [
                      createBaseVNode("label", _hoisted_9$1, toDisplayString(unref(it)("wallet.background.opacity")), 1)
                    ])
                  ]),
                  createBaseVNode("div", _hoisted_10$1, [
                    createBaseVNode("span", { class: "flex-none pr-3" }, toDisplayString(minOpacity) + "%"),
                    createBaseVNode("input", {
                      class: "flex-1 form-range w-full h-6 p-1 bg-transparent focus:outline-none focus:ring-0 focus:shadow-none",
                      type: "range",
                      ref_key: "bgOpacity",
                      ref: bgOpacity,
                      value: "80",
                      min: minOpacity,
                      max: maxOpacity,
                      step: opacitySteps,
                      onChange: changeOpacity
                    }, null, 544),
                    createBaseVNode("span", { class: "flex-none pl-3" }, toDisplayString(maxOpacity) + "%")
                  ])
                ])
              ])
            ])
          ]),
          showPreviewButton.value ? (openBlock(), createBlock(GridButtonSecondary, {
            key: 0,
            label: unref(it)("wallet.background.button.preview"),
            class: "col-span-6 md:col-span-3",
            onClick: withModifiers(testBackground, ["stop"])
          }, null, 8, ["label"])) : createCommentVNode("", true),
          !showPreviewButton.value && showClearPreviewButton.value ? (openBlock(), createBlock(GridButtonSecondary, {
            key: 1,
            label: unref(it)("wallet.background.button.clearPreview"),
            class: "col-span-6 md:col-span-3",
            onClick: withModifiers(clearPreview, ["stop"])
          }, null, 8, ["label"])) : createCommentVNode("", true),
          !unref(isBexApp)() ? (openBlock(), createBlock(GridButtonSecondary, {
            key: 2,
            label: unref(it)("wallet.background.button.randomMez"),
            class: "col-start-7 col-span-6 md:col-start-4 md:col-span-3",
            onClick: withModifiers(randomMez, ["stop"])
          }, null, 8, ["label"])) : createCommentVNode("", true),
          showClearBackgroundButton.value && !showClearPreviewButton.value ? (openBlock(), createBlock(GridButtonSecondary, {
            key: 3,
            label: unref(it)("wallet.background.button.remove"),
            class: "col-span-6 md:col-span-3",
            onClick: withModifiers(removeCurrentBackground, ["stop"])
          }, null, 8, ["label"])) : createCommentVNode("", true)
        ]),
        _: 1
      }, 8, ["form-id", "reset-button-label", "submit-button-label", "submit-disabled", "reset-disabled"]);
    };
  }
});
const _hoisted_1$d = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_2$9 = { class: "col-span-12 sm:col-span-6 flex flex-row items-center" };
const _hoisted_3$8 = { class: "mr-2" };
const _hoisted_4$7 = {
  key: 0,
  class: "col-span-12 sm:col-span-6 flex flex-row items-center"
};
const _hoisted_5$4 = { class: "mr-4" };
const _sfc_main$h = /* @__PURE__ */ defineComponent({
  __name: "GridFormWalletIcon",
  props: {
    textId: { type: String, required: false, default: "" },
    prefilledWalletName: { type: String, required: false, default: "" },
    prefilledGroupName: { type: String, required: false, default: "" },
    isUpdate: { type: Boolean, required: false, default: false },
    saving: { type: Boolean, required: false, default: false },
    inputCSS: { type: String, default: "cc-input" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const file = ref();
    const compressedImageData = ref();
    const imagePreview = ref();
    const showImagePreview = ref(false);
    ref(null);
    const onSubmit = async () => {
      emit("submit", {
        compressedImageData: LZString.compress(compressedImageData.value)
      });
      submitEnabled.value = false;
      onReset();
      removeOldUploadDisable.value = true;
    };
    const onReset = () => {
      file.value.value = "";
      compressedImageData.value = void 0;
      showImagePreview.value = false;
      submitEnabled.value = false;
    };
    const resetCurrentImage = () => {
      file.value.value = "";
      compressedImageData.value = void 0;
      showImagePreview.value = false;
      emit("submit", {
        compressedImageData: ""
      });
      removeOldUploadDisable.value = false;
      submitEnabled.value = false;
    };
    const regenerateIcon = async () => {
      var randomSeed = now();
      var random = Math.floor(Math.random() * 255);
      emit("submit", {
        seed: String(randomSeed * random)
      });
    };
    const submitEnabled = ref(false);
    const removeOldUploadDisable = ref(false);
    async function encodeImageFileAsURL(element) {
      if (file.value && file.value.files && file.value.files.length > 0) {
        const fileUploaded = file.value.files[0];
        const resizedImage = await resizeImageFile(fileUploaded, 60);
        compressedImageData.value = resizedImage;
        await showPreview();
        let previewImage = imagePreview.value;
        previewImage.height = 35;
        previewImage.width = 35;
        previewImage.src = resizedImage;
        submitEnabled.value = true;
      }
    }
    const showPreview = async () => {
      showImagePreview.value = true;
    };
    const handleFileUpload = async () => {
      await encodeImageFileAsURL(file.value);
    };
    const isChanged = computed(() => compressedImageData.value !== void 0);
    const chooseFiles = () => {
      const target = document.getElementById("iconFileUpload");
      if (target !== null) {
        target.click();
      }
    };
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$j, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "GridFormWalletIcon",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": unref(it)("common.label.save"),
        "submit-disabled": !submitEnabled.value || __props.saving,
        "reset-disabled": __props.saving || !isChanged.value
      }, {
        btnBack: withCtx(() => [
          createBaseVNode("div", _hoisted_1$d, [
            createBaseVNode("div", _hoisted_2$9, [
              createBaseVNode("span", _hoisted_3$8, toDisplayString(unref(it)("wallet.icon.upload")) + ": ", 1),
              createBaseVNode("input", {
                ref_key: "file",
                ref: file,
                class: "hidden mb-2",
                id: "iconFileUpload",
                onChange: _cache[0] || (_cache[0] = ($event) => handleFileUpload()),
                type: "file"
              }, null, 544),
              createVNode(_sfc_main$k, {
                onClick: chooseFiles,
                class: "col-span-5 inline-block w-48",
                label: unref(it)("common.label.selectFile")
              }, null, 8, ["label"])
            ]),
            showImagePreview.value ? (openBlock(), createElementBlock("div", _hoisted_4$7, [
              createBaseVNode("span", _hoisted_5$4, toDisplayString(unref(it)("common.label.preview")) + ": ", 1),
              createBaseVNode("img", {
                ref_key: "imagePreview",
                ref: imagePreview
              }, null, 512)
            ])) : createCommentVNode("", true),
            createVNode(GridSpace, { hr: "" })
          ]),
          removeOldUploadDisable.value ? (openBlock(), createBlock(GridButtonSecondary, {
            key: 0,
            label: unref(it)("common.label.removeCurrentImage"),
            class: "col-span-12 sm:col-star-1 sm:col-span-3",
            onClick: resetCurrentImage
          }, null, 8, ["label"])) : createCommentVNode("", true),
          !removeOldUploadDisable.value ? (openBlock(), createBlock(GridButtonSecondary, {
            key: 1,
            label: unref(it)("common.label.regenerateIcon"),
            class: "col-span-12 sm:col-star-4 sm:col-span-3",
            onClick: regenerateIcon
          }, null, 8, ["label"])) : createCommentVNode("", true)
        ]),
        _: 1
      }, 8, ["reset-button-label", "submit-button-label", "submit-disabled", "reset-disabled"]);
    };
  }
});
const _hoisted_1$c = { class: "w-full col-span-12 sm:col-span-6 cc-grid" };
const _sfc_main$g = /* @__PURE__ */ defineComponent({
  __name: "ExportWalletJson",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.exports" }
  },
  setup(__props) {
    const { it } = useTranslation();
    const { downloadWallet } = useDownload();
    const { selectedWalletId } = useSelectedAccount();
    const exportWallet = () => downloadWallet(createWalletDownloadable(selectedWalletId.value));
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$c, [
        createVNode(GridButtonSecondary, {
          class: "col-span-12 xs:col-span-8 lg:col-span-9 h-10",
          link: exportWallet,
          label: unref(it)(__props.textId + ".json.button.label"),
          icon: unref(it)(__props.textId + ".json.button.icon")
        }, null, 8, ["label", "icon"])
      ]);
    };
  }
});
const _sfc_main$f = /* @__PURE__ */ defineComponent({
  __name: "ForceWalletResync",
  props: {
    accountId: { type: String, required: false, default: void 0 },
    walletId: { type: String, required: false, default: void 0 },
    textId: { type: String, required: false, default: "wallet.settings.resync" }
  },
  setup(__props) {
    const props = __props;
    const { it } = useTranslation();
    const resyncWallet = () => {
      if (props.walletId) {
        dispatchSignalSync(doFullWalletResync + "_" + props.walletId);
      } else if (props.accountId) {
        dispatchSignalSyncTo(doFullAccountResync, props.accountId);
      }
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(_sfc_main$l, {
          text: unref(it)(__props.textId + ".info")
        }, null, 8, ["text"]),
        createVNode(GridButtonSecondary, {
          class: "col-span-12 xs:col-span-8 sm:col-span-6 xl:col-span-4",
          link: resyncWallet,
          label: unref(it)(__props.textId + ".button.resync.label"),
          icon: unref(it)(__props.textId + ".button.resync.icon")
        }, null, 8, ["label", "icon"])
      ], 64);
    };
  }
});
const _hoisted_1$b = { class: "cc-grid cc-text-sz dark:text-cc-gray" };
const _hoisted_2$8 = { class: "cc-grid" };
const _hoisted_3$7 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg ml-5" };
const _hoisted_4$6 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg ml-5" };
const _sfc_main$e = /* @__PURE__ */ defineComponent({
  __name: "SettingsWalletSpecific",
  setup(__props) {
    const route = useRoute();
    const $q = useQuasar();
    const { it } = useTranslation();
    const {
      selectedWalletId,
      walletSettings,
      appWallet
    } = useSelectedAccount();
    const isMnemonic = computed(() => {
      var _a;
      return ((_a = appWallet.value) == null ? void 0 : _a.isMnemonic) ?? false;
    });
    const {
      saving,
      name,
      groupName,
      background,
      plate,
      updateName,
      updateSpendingPassword,
      updateBackground,
      updatePlate
    } = walletSettings;
    const {
      openWalletPage
    } = useNavigation();
    const onSubmitWalletName = async (payload) => notifyUpdate(await updateName(payload));
    const onSubmitPassword = async (payload) => notifyUpdate(await updateSpendingPassword(payload.oldPassword, payload.password));
    const onSubmitBackground = async (bg) => notifyUpdate(await updateBackground(bg));
    const onSubmitPlate = async (_plate) => {
      if (_plate.compressedImageData) {
        plate.value.data = _plate.compressedImageData;
      }
      if (_plate.seed) {
        plate.value.image = _plate.seed;
        plate.value.data = "";
      }
      notifyUpdate(await updatePlate(plate.value));
    };
    const navigateToVerification = () => {
      openWalletPage("WalletVerification");
    };
    const notifyUpdate = (success, message) => {
      $q.notify({
        type: success ? "positive" : "negative",
        message: it("wallet.settings.message." + (success ? "success" : "failed")),
        position: "top-left"
      });
    };
    const expandedVerification = ref(false);
    watchEffect(() => {
      var _a, _b;
      expandedVerification.value = (((_b = (_a = route.params) == null ? void 0 : _a.tabid) == null ? void 0 : _b.toString()) ?? "") === "verification";
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$b, [
        createBaseVNode("div", _hoisted_2$8, [
          createVNode(_sfc_main$m, {
            label: unref(it)("wallet.settings.walletSpecific.headline")
          }, null, 8, ["label"]),
          createVNode(GridSpace, { hr: "" }),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.walletNameGroupPassword.label"),
            caption: unref(it)("wallet.settings.walletNameGroupPassword.caption")
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$n, {
                class: "col-span-12 lg:ml-5",
                "prefilled-wallet-name": unref(name),
                "prefilled-group-name": unref(groupName),
                "is-update": true,
                saving: unref(saving),
                onSubmit: onSubmitWalletName
              }, null, 8, ["prefilled-wallet-name", "prefilled-group-name", "saving"]),
              isMnemonic.value ? (openBlock(), createBlock(GridSpace, {
                key: 0,
                hr: "",
                class: "lg:ml-5"
              })) : createCommentVNode("", true),
              isMnemonic.value ? (openBlock(), createBlock(_sfc_main$o, {
                key: 1,
                class: "col-span-12 lg:ml-5",
                "text-id": "form.password.spending",
                saving: unref(saving),
                onSubmit: onSubmitPassword
              }, null, 8, ["saving"])) : createCommentVNode("", true)
            ]),
            _: 1
          }, 8, ["label", "caption"]),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.background.label"),
            caption: unref(it)("wallet.background.caption")
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$i, {
                class: "col-span-12 lg:ml-5",
                "text-id": "wallet.background",
                "is-update": true,
                saving: unref(saving),
                "background-data": unref(background),
                onSubmit: onSubmitBackground
              }, null, 8, ["saving", "background-data"])
            ]),
            _: 1
          }, 8, ["label", "caption"]),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.icon.label"),
            caption: unref(it)("wallet.icon.caption")
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$h, {
                class: "col-span-12 lg:ml-5",
                "text-id": "wallet.icon",
                "is-update": true,
                saving: unref(saving),
                onSubmit: onSubmitPlate
              }, null, 8, ["saving"])
            ]),
            _: 1
          }, 8, ["label", "caption"]),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.resync.label"),
            caption: unref(it)("wallet.settings.resync.caption")
          }, {
            setting: withCtx(() => [
              createBaseVNode("div", _hoisted_3$7, [
                createVNode(_sfc_main$f, { "wallet-id": unref(selectedWalletId) }, null, 8, ["wallet-id"])
              ])
            ]),
            _: 1
          }, 8, ["label", "caption"]),
          isMnemonic.value ? (openBlock(), createBlock(_sfc_main$p, {
            key: 0,
            label: unref(it)("wallet.settings.verification.label"),
            caption: unref(it)("wallet.settings.verification.caption"),
            "open-expanded": expandedVerification.value
          }, {
            setting: withCtx(() => [
              createBaseVNode("div", _hoisted_4$6, [
                createVNode(GridButtonSecondary, {
                  label: unref(it)("wallet.settings.verification.start"),
                  link: navigateToVerification,
                  class: "col-span-12 xs:col-span-8 sm:col-span-6 xl:col-span-4"
                }, null, 8, ["label"])
              ])
            ]),
            _: 1
          }, 8, ["label", "caption", "open-expanded"])) : createCommentVNode("", true),
          createVNode(_sfc_main$p, {
            dense: "",
            label: unref(it)("wallet.settings.exports.json.headline"),
            caption: unref(it)("wallet.settings.exports.json.caption")
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$g, { class: "ml-5 pr-6" })
            ]),
            _: 1
          }, 8, ["label", "caption"])
        ])
      ]);
    };
  }
});
const _sfc_main$d = /* @__PURE__ */ defineComponent({
  __name: "GFEAccountName",
  props: {
    prefilledAccountName: { type: String, required: false, default: "" },
    inputCSS: { type: String, default: "cc-input" },
    alwaysShowInfo: { type: Boolean, default: false },
    autofocus: { type: Boolean, required: false, default: false },
    resetCounter: { type: Number, required: true, default: 0 },
    autocomplete: { type: String, default: "name" },
    update: { type: Boolean, required: false, default: false }
  },
  emits: ["onSubmittable"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const accountName = ref(props.prefilledAccountName ?? "");
    const accountNameError = ref("");
    function validateAccountName(external) {
      let accountNameInput = accountName.value.trim();
      const isValid = accountNameInput.length >= 3 && accountNameInput.length < 41 || !external && accountNameInput.length === 0;
      if (!isValid) {
        accountNameError.value = it("form.accountname.error");
      } else {
        accountNameError.value = "";
      }
      emit("onSubmittable", {
        accountName: accountNameInput,
        submittable: accountNameInput.length >= 0 && isValid
      });
      return accountNameError.value;
    }
    let town = -1;
    watch(accountName, () => {
      clearTimeout(town);
      town = setTimeout(() => validateAccountName(false), 350);
    });
    watch(() => props.prefilledAccountName, (name) => {
      accountName.value = name;
    });
    watch(() => props.resetCounter, () => {
      onResetAccountName();
    });
    function onResetAccountName() {
      accountName.value = props.prefilledAccountName;
      accountNameError.value = "";
      setTimeout(() => {
        accountName.value = props.prefilledAccountName;
      }, 10);
    }
    onMounted(() => {
      validateAccountName(false);
    });
    return (_ctx, _cache) => {
      return openBlock(), createBlock(GridInput, {
        "input-text": accountName.value,
        "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => accountName.value = $event),
        "input-error": accountNameError.value,
        "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => accountNameError.value = $event),
        onLostFocus: validateAccountName,
        onEnter: validateAccountName,
        onReset: onResetAccountName,
        label: unref(it)("form.accountname.label"),
        "input-hint": unref(it)("form.accountname.hint"),
        "input-info": unref(it)("form.accountname.info"),
        "input-c-s-s": __props.inputCSS,
        autofocus: __props.autofocus,
        autocomplete: __props.autocomplete,
        alwaysShowInfo: __props.alwaysShowInfo,
        showReset: true,
        "input-id": "inputAccountName",
        "input-type": "text"
      }, {
        "icon-prepend": withCtx(() => [
          createVNode(IconPencil, { class: "h-5 w-5" })
        ]),
        _: 1
      }, 8, ["input-text", "input-error", "label", "input-hint", "input-info", "input-c-s-s", "autofocus", "autocomplete", "alwaysShowInfo"]);
    };
  }
});
const _sfc_main$c = /* @__PURE__ */ defineComponent({
  __name: "GridFormAccountName",
  props: {
    prefilledAccountName: { type: String, required: false, default: "" },
    isUpdate: { type: Boolean, required: false, default: false },
    saving: { type: Boolean, required: false, default: false },
    inputCSS: { type: String, default: "cc-input" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const resetCounter = ref(0);
    const submittable = reactive({
      accountName: false,
      groupName: !props.isUpdate
    });
    const errors = reactive({
      accountName: false,
      groupName: false
    });
    const accountName = ref("");
    ref("");
    const isSubmitting = ref(false);
    function onSetAccountName(payload) {
      isSubmitting.value = false;
      submittable.accountName = payload.submittable;
      errors.accountName = payload.error;
      if (submittable.accountName) {
        accountName.value = payload.accountName;
      }
    }
    async function onSubmit() {
      isSubmitting.value = true;
      emit("submit", {
        accountName: accountName.value
      });
    }
    function onReset() {
      resetCounter.value = resetCounter.value + 1;
    }
    const submitEnabled = computed(() => !errors.accountName && submittable.accountName && (!props.isUpdate || !(accountName.value.trim() === props.prefilledAccountName)));
    const isChanged = computed(() => accountName.value !== props.prefilledAccountName);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$j, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "accountName",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": unref(it)("common.label.save"),
        "submit-disabled": !submitEnabled.value || __props.saving || isSubmitting.value,
        "reset-disabled": __props.saving || !isChanged.value || isSubmitting.value
      }, {
        content: withCtx(() => [
          createVNode(_sfc_main$d, {
            class: "col-span-12",
            onOnSubmittable: onSetAccountName,
            "prefilled-account-name": __props.prefilledAccountName,
            "reset-counter": resetCounter.value,
            update: __props.isUpdate,
            "input-c-s-s": __props.inputCSS
          }, null, 8, ["prefilled-account-name", "reset-counter", "update", "input-c-s-s"]),
          createVNode(GridSpace, { dense: "" })
        ]),
        btnBack: withCtx(() => [
          renderSlot(_ctx.$slots, "btnBack")
        ]),
        _: 3
      }, 8, ["reset-button-label", "submit-button-label", "submit-disabled", "reset-disabled"]);
    };
  }
});
const _hoisted_1$a = { class: "w-full col-span-12 sm:col-span-6 grid grid-cols-12 cc-gap" };
const _hoisted_2$7 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_3$6 = { class: "flex flex-col cc-text-sz" };
const _hoisted_4$5 = { class: "flex flex-col content-center items-center justify-center p-4" };
const _sfc_main$b = /* @__PURE__ */ defineComponent({
  __name: "ExportAccountPubKey",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.exports" }
  },
  setup(__props) {
    useQuasar();
    const { it } = useTranslation();
    const { accountData } = useSelectedAccount();
    const open = ref(false);
    const acctPubKey = ref("");
    const canvasRef = ref(null);
    const optionsPubFormat = reactive([
      { id: "acct_xvk", label: "acct_xvk", hover: "Ed25519-bip32 extended public key", index: 0 },
      { id: "xpub", label: "xpub", hover: "Ed25519-bip32 extended public key", index: 1 },
      { id: "acct_vk", label: "acct_vk", hover: "Ed25519 public key", index: 2 }
    ]);
    const pubFormat = ref(1);
    function onPubFormatChange(index) {
      pubFormat.value = index;
      exportAccountPubKey();
    }
    const generateMarker = (addr) => {
      browser.toCanvas(canvasRef.value, addr, function(error) {
        if (error) console.error(error);
      });
    };
    async function exportAccountPubKey() {
      const data = accountData.value;
      if (data) {
        const index = open.value ? pubFormat.value : 0;
        const pub = data.account.pub;
        switch (index) {
          case 0:
            acctPubKey.value = getXvkFromXpub(pub);
            break;
          case 1:
            acctPubKey.value = pub;
            break;
          case 2:
            acctPubKey.value = getVkFromXpub(pub);
            break;
        }
        open.value = true;
        nextTick(() => {
          generateMarker(acctPubKey.value);
          pubFormat.value = index;
        });
      }
    }
    const onClose = () => {
      open.value = false;
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$a, [
        createVNode(GridButtonSecondary, {
          class: "col-span-12 xs:col-span-12 lg:col-span-12 h-10",
          link: exportAccountPubKey,
          label: unref(it)(__props.textId + ".accountPub.button.doexport.label"),
          icon: unref(it)(__props.textId + ".accountPub.button.doexport.icon")
        }, null, 8, ["label", "icon"]),
        open.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          "full-width-on-mobile": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_2$7, [
              createBaseVNode("div", _hoisted_3$6, [
                createVNode(_sfc_main$m, {
                  label: unref(it)(__props.textId + ".accountPub.hover")
                }, null, 8, ["label"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_4$5, [
              createBaseVNode("canvas", {
                ref_key: "canvasRef",
                ref: canvasRef,
                width: "212",
                height: "212",
                class: "shadow cc-rounded mb-4"
              }, null, 512),
              createVNode(_sfc_main$q, {
                tabs: optionsPubFormat,
                divider: false,
                onSelection: onPubFormatChange,
                index: pubFormat.value,
                class: "mt-2"
              }, {
                tab0: withCtx(() => _cache[0] || (_cache[0] = [])),
                tab1: withCtx(() => _cache[1] || (_cache[1] = [])),
                tab2: withCtx(() => _cache[2] || (_cache[2] = [])),
                _: 1
              }, 8, ["tabs", "index"]),
              createVNode(_sfc_main$r, {
                label: acctPubKey.value,
                "label-hover": unref(it)(__props.textId + ".accountPub.button.copy.hover"),
                "notification-text": unref(it)(__props.textId + ".accountPub.button.copy.notify"),
                "copy-text": acctPubKey.value,
                class: "break-all text-center mt-1 mb-4"
              }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$9 = { class: "col-span-12 grid grid-cols-12 lg:ml-6" };
const _hoisted_2$6 = { class: "col-span-12 flex flex-col flex-nowrap mb-2" };
const _hoisted_3$5 = { class: "col-span-12 flex flex-col flex-nowrap items-center justify-center mb-2" };
const _hoisted_4$4 = { class: "break-all text-center cc-addr mb-4" };
const _hoisted_5$3 = ["href", "download"];
const _sfc_main$a = /* @__PURE__ */ defineComponent({
  __name: "CatalystVoterData",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.voterData" },
    encCatalystKey: { type: String, required: true },
    forceShow: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const $q = useQuasar();
    const {
      selectedWalletId,
      selectedAccountId,
      walletSettings,
      appAccount,
      appWallet
    } = useSelectedAccount();
    const walletName = walletSettings.name;
    const {
      getLedgerPublicKey
    } = useLedgerDevice();
    const {
      initiateTrezor,
      getTrezorPublicKey,
      getTrezorDerivationTypeFromWalletId
    } = useTrezorDevice();
    const {
      getKeystonePublicKeyUR,
      handleMultiAccountScan
    } = useKeystoneDevice();
    const canvasRef = ref(null);
    const imageURL = ref("");
    const hasError = ref(false);
    const showPasswordModal = ref(false);
    const keystoneUR = ref();
    const showQr = ref(false);
    const { isBalanceVisible } = useBalanceVisible();
    const isQrVisible = computed(() => props.forceShow || isBalanceVisible.value && showQr.value);
    const showInformation = (payload) => {
      var _a;
      const rootKey = (_a = appWallet.value) == null ? void 0 : _a.data.wallet.rootKey;
      if (rootKey == null ? void 0 : rootKey.prv) {
        if (decryptText(rootKey.prv, payload.password, rootKey.v ?? "")) {
          showQr.value = true;
          generateMarker();
        } else {
          $q.notify({
            type: "negative",
            message: t("wallet.settings.voterData.password.wrong"),
            position: "top-left",
            timeout: 6e3,
            closeBtn: true
          });
        }
        showPasswordModal.value = false;
      }
    };
    const generateMarker = async () => {
      if (!appAccount.value || !props.encCatalystKey) {
        return;
      }
      try {
        await browser.toCanvas(canvasRef.value, props.encCatalystKey);
        imageURL.value = canvasRef.value.toDataURL();
      } catch (err) {
        console.error(err);
        hasError.value = true;
      }
    };
    const qrCodeFileName = computed(() => {
      var _a, _b;
      const _walletName = ((_a = walletName.value) == null ? void 0 : _a.toLowerCase()) ?? "";
      const accountIndex = ((_b = appAccount.value) == null ? void 0 : _b.data.keys.index) ?? -1;
      return "catalyst_reg_" + _walletName.replace(/\s/g, "_") + "_acc_" + accountIndex.toString() + ".png";
    });
    const onDownloadQRCode = async (imgDataUrl, fileName) => {
      if (isMobileApp()) {
        const { _downloadPNG } = await __vitePreload(async () => {
          const { _downloadPNG: _downloadPNG2 } = await import("./useDownload2.js").then((n) => n.u);
          return { _downloadPNG: _downloadPNG2 };
        }, true ? __vite__mapDeps([0,1,2,3,4]) : void 0);
        _downloadPNG(imgDataUrl, fileName);
      }
    };
    const toggleVisibility = async () => {
      var _a, _b, _c, _d, _e;
      if ((_a = appAccount.value) == null ? void 0 : _a.isMnemonic) {
        showPasswordModal.value = true;
      } else {
        const pubKeyList = [];
        const accountData = (_b = appAccount.value) == null ? void 0 : _b.data;
        if (!accountData) return;
        try {
          if ((_c = appAccount.value) == null ? void 0 : _c.isLedger) {
            pubKeyList.push(...await getLedgerPublicKey(purpose.hdwallet, 0, 0, [accountData.keys.index]));
          } else if ((_d = appAccount.value) == null ? void 0 : _d.isTrezor) {
            const features = await initiateTrezor();
            pubKeyList.push(...await getTrezorPublicKey(purpose.hdwallet, 0, 0, [accountData.keys.index], getTrezorDerivationTypeFromWalletId(selectedWalletId.value ?? "")));
          } else if ((_e = appAccount.value) == null ? void 0 : _e.isKeystone) {
            const publicKeyUR = getKeystonePublicKeyUR(purpose.hdwallet, 0, 0, [accountData.keys.index]);
            const signResult = await signWithKeystone(publicKeyUR);
            if (signResult.pubKeyList) {
              pubKeyList.push(...signResult.pubKeyList);
            }
          }
          if (accountData.account.pub !== pubKeyList[0]) {
            throw new Error("Device mismatch");
          } else {
            showQr.value = true;
            generateMarker();
          }
        } catch (error) {
          $q.notify({
            type: "negative",
            message: error.message,
            position: "top-left",
            timeout: 6e3,
            closeBtn: true
          });
        }
      }
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
    onMounted(async () => generateMarker());
    return (_ctx, _cache) => {
      var _a, _b;
      return openBlock(), createElementBlock(Fragment, null, [
        ((_a = unref(appAccount)) == null ? void 0 : _a.isKeystone) ? (openBlock(), createBlock(_sfc_main$s, {
          key: 0,
          open: !!keystoneUR.value,
          "keystone-u-r": keystoneUR.value,
          onClose: onKeystoneClose,
          onDecode: onKeystoneScan
        }, null, 8, ["open", "keystone-u-r"])) : createCommentVNode("", true),
        createVNode(_sfc_main$t, {
          "show-modal": showPasswordModal.value,
          textId: "wallet.settings.voterData.password",
          title: unref(t)("wallet.settings.voterData.password.title"),
          caption: unref(t)("wallet.settings.voterData.password.caption"),
          "submit-button-label": unref(t)("wallet.settings.voterData.password.confirm"),
          onClose: _cache[0] || (_cache[0] = ($event) => showPasswordModal.value = false),
          onSubmit: showInformation
        }, null, 8, ["show-modal", "title", "caption", "submit-button-label"]),
        createBaseVNode("div", _hoisted_1$9, [
          withDirectives(createBaseVNode("div", _hoisted_2$6, [
            createVNode(_sfc_main$u, {
              text: ((_b = unref(appAccount)) == null ? void 0 : _b.isMnemonic) ? unref(t)(__props.textId + ".mnemonic.info") : unref(t)(__props.textId + ".hardware.info"),
              icon: "mdi mdi-alert-octagon-outline",
              class: "col-span-12 mb-2",
              "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
              css: "cc-rounded cc-banner-warning"
            }, null, 8, ["text"]),
            createVNode(GridButtonSecondary, {
              class: "xs:col-span-8 sm:col-span-6 xl:col-span-4 mb-2",
              link: toggleVisibility,
              label: unref(t)(__props.textId + ".button.showQR"),
              icon: "mdi mdi-eye-off"
            }, null, 8, ["label"])
          ], 512), [
            [vShow, !isQrVisible.value]
          ]),
          withDirectives(createBaseVNode("div", _hoisted_3$5, [
            createVNode(_sfc_main$u, {
              text: hasError.value ? unref(t)(__props.textId + ".error") : unref(t)(__props.textId + ".warning"),
              icon: "mdi mdi-alert-octagon-outline",
              class: "col-span-12 mb-2",
              "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
              css: "cc-rounded cc-banner-warning"
            }, null, 8, ["text"]),
            createVNode(_sfc_main$l, {
              text: unref(t)(__props.textId + ".info"),
              class: "col-span-12 mt-2"
            }, null, 8, ["text"]),
            createBaseVNode("canvas", {
              ref_key: "canvasRef",
              ref: canvasRef,
              width: "212",
              height: "212",
              class: "shadow cc-rounded mt-4 mb-4"
            }, null, 512),
            createBaseVNode("div", _hoisted_4$4, toDisplayString(__props.encCatalystKey), 1),
            createVNode(_sfc_main$r, {
              label: unref(t)(__props.textId + ".copy.label"),
              "label-hover": unref(t)(__props.textId + ".copy.hover"),
              "notification-text": unref(t)(__props.textId + ".copy.notify"),
              "copy-text": __props.encCatalystKey,
              class: "cc-flex-fixed inline flex items-center justify-center mb-2"
            }, null, 8, ["label", "label-hover", "notification-text", "copy-text"]),
            createBaseVNode("a", {
              class: "mt-1 text-2xl cc-text-semi-bold rounded-md border px-4 py-2",
              href: imageURL.value,
              download: qrCodeFileName.value,
              onClick: _cache[1] || (_cache[1] = withModifiers(($event) => onDownloadQRCode(imageURL.value, qrCodeFileName.value), ["stop"]))
            }, [
              createTextVNode(toDisplayString(unref(t)(__props.textId + ".download.label")) + " ", 1),
              createVNode(_sfc_main$v, {
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(unref(t)(__props.textId + ".download.hover")), 1)
                ]),
                _: 1
              })
            ], 8, _hoisted_5$3)
          ], 512), [
            [vShow, isQrVisible.value]
          ])
        ])
      ], 64);
    };
  }
});
const _hoisted_1$8 = { class: "cc-grid" };
const _hoisted_2$5 = ["innerHTML"];
const _sfc_main$9 = /* @__PURE__ */ defineComponent({
  __name: "SendAddrInput",
  props: {
    textId: { type: String, required: true, default: "" },
    nextLabel: { type: String, required: false },
    prefilledAddress: { type: String, required: false }
  },
  emits: ["submit", "bridgeUpdate"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    useQuasar();
    const { it } = useTranslation();
    const {
      accountData
    } = useSelectedAccount();
    const addrInput = ref(props.prefilledAddress ?? "");
    const addrInputError = ref("");
    const addrInputAppend = ref("");
    const isScriptAddr = ref(false);
    const validReceiveAddr = ref(true);
    const validMetaInput = ref(true);
    let timeoutId = -1;
    const validateAddrInput = async () => {
      addrInputError.value = "";
      addrInputAppend.value = "";
      if (!addrInput.value || addrInput.value.length === 0) {
        return;
      }
      if (!accountData.value) {
        addrInputError.value = it("wallet.send.error.account");
      } else {
        let addr = addrInput.value;
        if (!isValidSendAddress(networkId.value, addr)) {
          addrInputError.value = it(props.textId + ".error");
        }
      }
    };
    const validateAddr = () => {
      if ((addrInput.value.length > 0 && addrInput.value !== "$" || addrInput.value.length === 0) && addrInputError.value.length === 0) {
        validReceiveAddr.value = true;
      }
    };
    const onAddrInputUpdate = (value) => {
      clearTimeout(timeoutId);
      addrInput.value = value;
      addrInputError.value = "";
      addrInputAppend.value = "";
      validReceiveAddr.value = true;
      isScriptAddr.value = false;
      timeoutId = setTimeout(async () => {
        await validateAddrInput();
        validateAddr();
      }, 50);
    };
    const onQrCode = (payload) => {
      onAddrInputUpdate(payload.content);
    };
    const onReset = () => {
      addrInput.value = "";
      addrInputError.value = "";
      addrInputAppend.value = "";
      validReceiveAddr.value = true;
      isScriptAddr.value = false;
      onSubmit();
    };
    const onSubmit = async () => {
      if (!validReceiveAddr.value || !validMetaInput.value) {
        return;
      }
      if (accountData.value) {
        emit("submit", addrInput.value);
      }
    };
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
      onAddrInputUpdate(clipboardData.trim().split(/(\s+)/).sort((a, b) => a.length - b.length).pop() ?? "");
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
      return openBlock(), createElementBlock("div", _hoisted_1$8, [
        createVNode(GridInputAutocomplete, {
          "input-text": addrInput.value,
          "onUpdate:inputText": [
            _cache[0] || (_cache[0] = ($event) => addrInput.value = $event),
            onAddrInputUpdate
          ],
          "input-error": addrInputError.value,
          "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => addrInputError.value = $event),
          "input-hint": unref(it)(__props.textId + ".hint"),
          "input-text-c-s-s": "cc-text-color",
          "input-disabled": false,
          alwaysShowInfo: false,
          showReset: addrInput.value.length > 0,
          onEnter: onSubmit,
          onReset,
          onPaste,
          autocomplete: "off",
          "input-id": "inputAddr",
          "input-type": "text",
          class: "col-span-12 md:col-span-11"
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error", "input-hint", "showReset"]),
        createVNode(_sfc_main$w, {
          onDecode: onQrCode,
          "button-css": "col-start-0 col-span-6 md:col-start-12 md:col-span-1 h-9 sm:h-11"
        }),
        addrInputAppend.value ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: "col-span-12 flex flex-col flex-nowrap justify-start items-start",
          innerHTML: addrInputAppend.value
        }, null, 8, _hoisted_2$5)) : (openBlock(), createBlock(_sfc_main$k, {
          key: 1,
          label: __props.nextLabel ?? unref(it)("common.label.next"),
          link: onSubmit,
          disabled: !validReceiveAddr.value || !validMetaInput.value,
          class: "col-start-7 col-span-6 md:col-start-10 md:col-span-3"
        }, null, 8, ["label", "disabled"]))
      ]);
    };
  }
});
const _hoisted_1$7 = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_2$4 = { class: "col-span-12 flex flex-col items-baseline" };
const _hoisted_3$4 = { class: "cc-text-semi-bold" };
const _hoisted_4$3 = {
  key: 0,
  class: "break-all font-mono"
};
const _hoisted_5$2 = {
  key: 1,
  class: "break-all font-mono"
};
const _sfc_main$8 = /* @__PURE__ */ defineComponent({
  __name: "ChangeAddress",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.sam" }
  },
  emits: ["saveSetting"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const $q = useQuasar();
    const {
      selectedAccountId,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const samAddr = accountSettings.samAddr;
    const changeAddr = ref(samAddr.value || "");
    function onSetChangeAddress(address) {
      const _accountData = accountData.value;
      if (!_accountData) {
        return;
      }
      if (address) {
        let type = getAddressType([_accountData.keys], address);
        if (type === null) {
          $q.notify({
            type: "negative",
            message: it("wallet.settings.namiMessages.notOwned"),
            position: "top-left"
          });
          return;
        } else if (type === "external") {
          $q.notify({
            type: "warning",
            message: it("wallet.settings.namiMessages.nonStaking"),
            position: "top-left"
          });
        }
      }
      emit("saveSetting", { address });
      changeAddr.value = address;
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", _hoisted_1$7, [
          createVNode(_sfc_main$u, {
            class: "col-span-12",
            css: "cc-rounded cc-banner-warning",
            dense: "",
            label: unref(it)(__props.textId + ".notice.label"),
            text: unref(it)(__props.textId + ".notice.text"),
            icon: unref(it)(__props.textId + ".notice.icon")
          }, null, 8, ["label", "text", "icon"]),
          createVNode(GridSpace, { hr: "" }),
          createBaseVNode("div", _hoisted_2$4, [
            createBaseVNode("span", _hoisted_3$4, toDisplayString(unref(it)(__props.textId + ".current")) + " ", 1),
            changeAddr.value ? (openBlock(), createElementBlock("span", _hoisted_4$3, toDisplayString(changeAddr.value), 1)) : (openBlock(), createElementBlock("span", _hoisted_5$2, "not set (default)"))
          ]),
          createVNode(GridSpace, { hr: "" })
        ]),
        createVNode(_sfc_main$9, {
          "text-id": __props.textId,
          "next-label": unref(it)("common.label.save"),
          "prefilled-address": changeAddr.value,
          onSubmit: onSetChangeAddress
        }, null, 8, ["text-id", "next-label", "prefilled-address"])
      ], 64);
    };
  }
});
const _hoisted_1$6 = { class: "col-span-full" };
const _hoisted_2$3 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12"
};
const _hoisted_3$3 = { class: "col-span-12 mb-2" };
const _hoisted_4$2 = { class: "col-span-6 grid grid-cols-12" };
const _hoisted_5$1 = {
  key: 1,
  class: "col-span-12 mt-2"
};
const _hoisted_6$1 = {
  key: 2,
  class: "col-span-12 mt-3"
};
const _hoisted_7$1 = { class: "col-span-12 p-2 grid grid-cols-12 cc-gap ring-2 ring-yellow-500 cc-rounded mb-2 mt-3" };
const _hoisted_8$1 = { class: "col-span-12 flex flex-row flex-nowrap whitespace-pre-wrap text-yellow-500 cc-text-bold" };
const _hoisted_9 = { class: "col-span-12" };
const _hoisted_10 = { key: 0 };
const _hoisted_11 = { class: "italic underline" };
const _sfc_main$7 = /* @__PURE__ */ defineComponent({
  __name: "Collateral",
  props: {
    enabled: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const $q = useQuasar();
    const { it } = useTranslation();
    const {
      selectedAccountId,
      selectedWalletId,
      appAccount,
      appWallet,
      accountData,
      accountSettings,
      utxoMap
    } = useSelectedAccount();
    const isCollateralEnabled = accountSettings.isCollateralEnabled;
    const toggleCollateral = accountSettings.toggleCollateral;
    const { formatADAString } = useFormatter();
    const { adaSymbol } = useAdaSymbol();
    const minimumCollateral = formatADAString(minCollateral(networkId.value), true, 0);
    const maximumCollateral = formatADAString(maxCollateral(networkId.value), true, 0);
    const isMultiAccountWallet = computed(() => !!appWallet.value && appWallet.value.data.wallet.accountList.length > 1);
    const hasBuildError = ref(false);
    const buildErrorMsg = ref("");
    const collateralUtxo = ref([]);
    watchEffect(async () => {
      var _a;
      const collateralUtxoList = ((_a = utxoMap.value) == null ? void 0 : _a.collateral) ?? [];
      console.log("RESULT", collateralUtxoList);
      collateralUtxo.value = collateralUtxoList;
    });
    const setCollateral = async () => {
      if (!isCollateralEnabled.value) {
        await toggleCollateral();
      }
      addSignalListener(onBuiltTxCollateral, "Collateral", (res, error) => {
        removeSignalListener(onBuiltTxCollateral, "Collateral");
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
      await dispatchSignal(doBuildTxCollateral);
      removeSignalListener(onBuiltTxCollateral, "Collateral");
    };
    const getPathInfo = (addr) => {
      if (accountData.value) {
        const cred = getOwnedCredFromAddrBech32([accountData.value.keys], addr);
        if (cred) {
          return getDerivationPath(cred.path);
        }
      }
      return "";
    };
    const collateralItemList = computed(() => {
      const list = [];
      const map = {};
      if (collateralUtxo.value.length > 0) {
        for (const utxo of collateralUtxo.value) {
          let item = map[utxo.output.address];
          if (!item) {
            item = {
              bech32: utxo.output.address,
              list: [utxo],
              pathInfo: getPathInfo(utxo.output.address)
            };
            map[utxo.output.address] = item;
            list.push(item);
          } else {
            item.list.push(utxo);
          }
        }
      }
      return list;
    });
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock("div", _hoisted_1$6, [
        (((_a = collateralUtxo.value) == null ? void 0 : _a.length) ?? 0) === 0 ? (openBlock(), createElementBlock("div", _hoisted_2$3, [
          createBaseVNode("div", _hoisted_3$3, toDisplayString(unref(it)("wallet.settings.collateral.noCollateral")), 1),
          createBaseVNode("div", _hoisted_4$2, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("wallet.settings.collateral.button"),
              link: setCollateral,
              class: "col-span-9"
            }, null, 8, ["label"])
          ])
        ])) : (openBlock(), createElementBlock("div", _hoisted_5$1, [
          createTextVNode(toDisplayString(unref(it)("wallet.settings.collateral.foundCollateral")) + " ", 1),
          (openBlock(true), createElementBlock(Fragment, null, renderList(collateralItemList.value, (utxo) => {
            return openBlock(), createBlock(_sfc_main$x, {
              class: "col-span-12 cc-text-sz mt-2",
              "utxo-item": utxo,
              "hide-lock": ""
            }, null, 8, ["utxo-item"]);
          }), 256))
        ])),
        hasBuildError.value ? (openBlock(), createElementBlock("div", _hoisted_6$1, [
          hasBuildError.value ? (openBlock(), createBlock(_sfc_main$u, {
            key: 0,
            label: unref(it)("wallet.settings.collateral.error.label"),
            text: buildErrorMsg.value,
            icon: unref(it)("wallet.settings.collateral.error.icon"),
            class: "col-span-12 mt-2 sm:mt-4",
            "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
            css: "cc-rounded cc-banner-warning"
          }, null, 8, ["label", "text", "icon"])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_7$1, [
          createBaseVNode("div", _hoisted_8$1, toDisplayString(unref(it)("wallet.settings.collateral.multiAccount.warning.note")), 1),
          createBaseVNode("div", _hoisted_9, [
            isMultiAccountWallet.value ? (openBlock(), createElementBlock("div", _hoisted_10, [
              createBaseVNode("div", _hoisted_11, toDisplayString(unref(it)("wallet.settings.collateral.multiAccount.warning.headline")), 1)
            ])) : createCommentVNode("", true),
            createBaseVNode("div", null, [
              createBaseVNode("div", {
                class: normalizeClass(isMultiAccountWallet.value ? "mt-3" : "")
              }, toDisplayString(unref(it)("wallet.settings.collateral.multiAccount.info.line1").replace("####minimumCollateral####", unref(minimumCollateral)).replace("####maximumCollateral####", unref(maximumCollateral))), 3)
            ])
          ])
        ])
      ]);
    };
  }
});
const _hoisted_1$5 = { class: "col-span-12 grid grid-cols-12 auto-rows-max cc-gap" };
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "TokenFragmentation",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.tokenfrag" }
  },
  emits: ["saveSetting"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const {
      accountSettings
    } = useSelectedAccount();
    const tfBundleSize = accountSettings.tfBundleSize;
    const saving = ref(false);
    const fragInput = ref(tfBundleSize.value.toString());
    const fragInputError = ref("");
    function validateFragInput(value) {
      fragInputError.value = "";
      if (value) {
        value = value.replace(/[^0-9]/g, "");
        fragInput.value = isZero(value) ? "0" : fragInput.value === "0" ? value.replace(/0/g, "") : value;
        if (value.length === 0 || compare(value, "<=", 0) || compare(fragInput.value, ">", 150)) {
          fragInputError.value = t(props.textId + ".fragment.error");
        }
      } else {
        fragInput.value = "0";
        fragInputError.value = t(props.textId + ".fragment.error");
      }
    }
    async function onSetFragmentation() {
      if (fragInputError.value === "") {
        emit("saveSetting", Number(fragInput.value));
      }
    }
    function onReset() {
      fragInput.value = "20";
      fragInputError.value = "";
    }
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$j, {
        class: "col-span-12 grid grid-cols-12 cc-gap",
        onDoFormReset: onReset,
        onDoFormSubmit: onSetFragmentation,
        "form-id": "TokenFragmentation",
        "reset-button-label": unref(t)(__props.textId + ".button.default"),
        "submit-button-label": unref(t)(__props.textId + ".button.save"),
        "submit-disabled": !validateFragInput || saving.value
      }, {
        content: withCtx(() => [
          createBaseVNode("div", _hoisted_1$5, [
            createVNode(GridInput, {
              class: "col-span-12 mt-2 sm:mt-0",
              "input-text": fragInput.value,
              "onUpdate:inputText": validateFragInput,
              "input-error": fragInputError.value,
              "onUpdate:inputError": _cache[0] || (_cache[0] = ($event) => fragInputError.value = $event),
              onOnEnter: onSetFragmentation,
              label: unref(t)(__props.textId + ".fragment.label"),
              alwaysShowInfo: false,
              "input-id": "fragmentInput",
              autocomplete: "off"
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label"]),
            createVNode(_sfc_main$l, {
              text: unref(t)(__props.textId + ".fragment.info"),
              class: "cc-shadow cc-rounded"
            }, null, 8, ["text"])
          ]),
          createVNode(GridSpace, { dense: "" })
        ]),
        btnBack: withCtx(() => [
          renderSlot(_ctx.$slots, "btnBack")
        ]),
        _: 3
      }, 8, ["reset-button-label", "submit-button-label", "submit-disabled"]);
    };
  }
});
const _hoisted_1$4 = {
  key: 0,
  class: "w-full col-span-12 grid grid-cols-12 auto-rows-min cc-gap"
};
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "DeregisterWallet",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.deldereg.deregwallet" }
  },
  setup(__props) {
    var _a;
    const $q = useQuasar();
    const { it } = useTranslation();
    const { adaSymbol } = useAdaSymbol();
    const {
      selectedAccountId,
      selectedWalletId,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const rewardInfo = accountSettings.rewardInfo;
    const hasUTxOs = accountSettings.hasUTxOs;
    const toggled = ref(false);
    const toggleError = computed(() => toggled.value);
    const isRegistered = ((_a = rewardInfo.value) == null ? void 0 : _a.registered) ?? false;
    async function deregister() {
      addSignalListener(onBuiltTxDeregistration, "DeregisterWallet", (res, error) => {
        removeSignalListener(onBuiltTxDeregistration, "DeregisterWallet");
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
      await dispatchSignal(doBuildTxDeregistration);
      removeSignalListener(onBuiltTxDeregistration, "DeregisterWallet");
    }
    return (_ctx, _cache) => {
      return unref(isRegistered) ? (openBlock(), createElementBlock("div", _hoisted_1$4, [
        createVNode(_sfc_main$l, {
          text: unref(it)(__props.textId + ".caption")
        }, null, 8, ["text"]),
        createVNode(_sfc_main$y, {
          label: unref(it)(__props.textId + ".toggle.acknowledged.label"),
          text: toggleError.value ? unref(it)(__props.textId + ".toggle.acknowledged.noutxo") : unref(it)(__props.textId + ".toggle.acknowledged.text"),
          icon: unref(it)(__props.textId + ".toggle.acknowledged.icon"),
          toggled: toggled.value,
          toggleError: toggleError.value,
          "onUpdate:toggled": _cache[0] || (_cache[0] = ($event) => toggled.value = $event),
          class: "col-span-12"
        }, null, 8, ["label", "text", "icon", "toggled", "toggleError"]),
        createVNode(_sfc_main$z, {
          class: "col-span-12 mt-1",
          link: deregister,
          disabled: !toggled.value || !unref(hasUTxOs),
          label: unref(it)(__props.textId + ".button.dereg.label"),
          icon: unref(it)(__props.textId + ".button.dereg.icon")
        }, null, 8, ["disabled", "label", "icon"])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$3 = {
  key: 0,
  class: "w-full col-span-12 grid grid-cols-12 auto-rows-min cc-gap"
};
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "DeregisterDRep",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.deldereg.deregdrep" }
  },
  setup(__props) {
    var _a;
    const $q = useQuasar();
    const { it } = useTranslation();
    const { adaSymbol } = useAdaSymbol();
    const {
      selectedAccountId,
      selectedWalletId,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const rewardInfo = accountSettings.rewardInfo;
    const hasUTxOs = accountSettings.hasUTxOs;
    const toggled = ref(false);
    const toggleError = computed(() => toggled.value);
    const isRegistered = ((_a = rewardInfo.value) == null ? void 0 : _a.registered) ?? false;
    async function deregister() {
      addSignalListener(onBuiltTxDRepDeregistration, "DeregisterDrep", (res, error) => {
        removeSignalListener(onBuiltTxDRepDeregistration, "DeregisterDrep");
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
      await dispatchSignal(doBuildTxDRepDeregistration);
      removeSignalListener(onBuiltTxDRepDeregistration, "DeregisterDrep");
    }
    return (_ctx, _cache) => {
      return unref(isRegistered) ? (openBlock(), createElementBlock("div", _hoisted_1$3, [
        createVNode(_sfc_main$l, {
          text: unref(it)(__props.textId + ".caption")
        }, null, 8, ["text"]),
        createVNode(_sfc_main$y, {
          label: unref(it)(__props.textId + ".toggle.acknowledged.label"),
          text: toggleError.value ? unref(it)(__props.textId + ".toggle.acknowledged.noutxo") : unref(it)(__props.textId + ".toggle.acknowledged.text"),
          icon: unref(it)(__props.textId + ".toggle.acknowledged.icon"),
          toggled: toggled.value,
          toggleError: toggleError.value,
          "onUpdate:toggled": _cache[0] || (_cache[0] = ($event) => toggled.value = $event),
          class: "col-span-12"
        }, null, 8, ["label", "text", "icon", "toggled", "toggleError"]),
        createVNode(_sfc_main$z, {
          class: "col-span-12 mt-1",
          link: deregister,
          disabled: !toggled.value || !unref(hasUTxOs),
          label: unref(it)(__props.textId + ".button.dereg.label"),
          icon: unref(it)(__props.textId + ".button.dereg.icon")
        }, null, 8, ["disabled", "label", "icon"])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$2 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 cc-gap cc-text-sz"
};
const _hoisted_2$2 = { class: "col-span-12 grid grid-cols-12 cc-gap mb-2" };
const _hoisted_3$2 = ["selected", "value"];
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "ReportingAccount",
  setup(__props) {
    const $q = useQuasar();
    const { it } = useTranslation();
    const { accountSettings } = useSelectedAccount();
    const {
      reportingAccountType,
      updateReportingAccountType
    } = accountSettings;
    const typeList = ref([
      { value: ReportingAccountType.manual, label: "confirm" },
      { value: ReportingAccountType.allIncome, label: "all-income" },
      { value: ReportingAccountType.passThrough, label: "pass-through" }
    ]);
    const setType = async (event) => {
      const option = event.target.options[event.target.options.selectedIndex];
      const label = (option == null ? void 0 : option.label) ?? "unknown";
      const type = Number((option == null ? void 0 : option.value) ?? ReportingAccountType.manual);
      switch (type) {
        case ReportingAccountType.allIncome:
        case ReportingAccountType.manual:
        case ReportingAccountType.passThrough:
          notifyUpdate(await updateReportingAccountType(type));
          break;
        default:
          notifyUpdate(false, "Invalid reporting account type: " + label);
          break;
      }
    };
    const notifyUpdate = (success, message) => {
      $q.notify({
        type: success ? "positive" : "negative",
        message: message ? message : it("wallet.settings.message." + (success ? "success" : "failed")),
        position: "top-left"
      });
    };
    return (_ctx, _cache) => {
      return typeList.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1$2, [
        createBaseVNode("div", _hoisted_2$2, [
          createVNode(_sfc_main$m, {
            class: "col-span-12",
            label: "Account type"
          }),
          createBaseVNode("select", {
            class: "col-span-12 sm:col-span-6 xl:col-span-4 cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[0] || (_cache[0] = ($event) => setType($event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(typeList.value, (data) => {
              return openBlock(), createElementBlock("option", {
                key: data.label,
                selected: data.value === unref(reportingAccountType),
                value: data.value
              }, toDisplayString(data.label), 9, _hoisted_3$2);
            }), 128))
          ], 32)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$1 = { class: "cc-grid cc-text-sz dark:text-cc-gray" };
const _hoisted_2$1 = {
  key: 0,
  class: "cc-grid"
};
const _hoisted_3$1 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg lg:ml-5 bg-cc-dark" };
const _hoisted_4$1 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg lg:ml-5" };
const _hoisted_5 = { class: "col-span-12 lg:ml-6 p-2 grid grid-cols-12 cc-gap cc-rounded cc-ring-red mb-2" };
const _hoisted_6 = { class: "col-span-12 flex flex-row flex-nowrap justify-center items-center whitespace-pre-wrap cc-text-bold cc-text-red-light" };
const _hoisted_7 = { class: "col-span-12 lg:ml-6 p-2 grid grid-cols-12 cc-gap cc-rounded cc-ring-red mb-2" };
const _hoisted_8 = { class: "col-span-12 flex flex-row flex-nowrap justify-center items-center whitespace-pre-wrap cc-text-bold cc-text-red-light" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "SettingsAccount",
  props: {
    openSetting: { type: String, required: false, default: "" }
  },
  setup(__props) {
    const storeId = "SettingsAccount" + getRandomId();
    const props = __props;
    const $q = useQuasar();
    const { it } = useTranslation();
    const {
      selectedWalletId,
      appWallet,
      selectedAccountId,
      appAccount,
      accountSettings,
      walletSettings
    } = useSelectedAccount();
    const {
      saving,
      name,
      updateAccountName,
      isCollateralEnabled,
      toggleCollateral,
      isAumEnabled,
      toggleAUM,
      isAwEnabled,
      toggleAW,
      isSamEnabled,
      toggleSAM,
      updateSAMAddress,
      isSendAllEnabled,
      toggleSendAll,
      isManualSyncEnabled,
      toggleManualSync,
      isHistorySyncEnabled,
      toggleHistorySync,
      isTfEnabled,
      toggleTF,
      tfBundleSize,
      updateTFBundleSize,
      hasCatalystData,
      catalystData
    } = accountSettings;
    const notifyUpdate = (success, message) => {
      $q.notify({
        type: success ? "positive" : "negative",
        message: it("wallet.settings.message." + (success ? "success" : "failed")),
        position: "top-left"
      });
    };
    const onToggleAUM = async () => notifyUpdate(await toggleAUM());
    const onToggleAW = async () => notifyUpdate(await toggleAW());
    const onToggleSAM = async () => notifyUpdate(await toggleSAM());
    const onToggleSendAll = async () => notifyUpdate(await toggleSendAll());
    const onToggleManualSync = async () => notifyUpdate(await toggleManualSync());
    const onToggleHistorySync = async () => notifyUpdate(await toggleHistorySync());
    const onToggleTF = async () => notifyUpdate(await toggleTF());
    const onUpdateTFBundleSize = async (bundleSize) => notifyUpdate(await updateTFBundleSize(bundleSize));
    const onSubmitAccountName = async (payload) => notifyUpdate(await updateAccountName(payload.accountName));
    const onSubmitSAMAddress = async (payload) => notifyUpdate(await updateSAMAddress(payload.address));
    const onApplySAMGlobal = async () => notifyUpdate(await walletSettings.setSAM(isSamEnabled.value));
    const onApplyManualSync = async () => notifyUpdate(await walletSettings.setManualSync(isManualSyncEnabled.value));
    const onApplyHistorySync = async () => notifyUpdate(await walletSettings.setHistorySync(isHistorySyncEnabled.value));
    const onApplyTF = async () => notifyUpdate(await walletSettings.setTF(isTfEnabled.value, tfBundleSize.value));
    const onApplyAUM = async () => notifyUpdate(await walletSettings.setAUM(isAumEnabled.value));
    const onApplyAW = async () => notifyUpdate(await walletSettings.setAW(isAwEnabled.value));
    const onApplySendAll = async () => notifyUpdate(await walletSettings.setSendAll(isSendAllEnabled.value));
    ref(false);
    ref(false);
    ref(false);
    const expandedVoterData = ref(props.openSetting === "catalyst");
    const stakeIsEnabled = ref(isStakingEnabled(networkId.value));
    const updateStakeEnabledStatus = () => {
      stakeIsEnabled.value = isStakingEnabled(networkId.value);
    };
    onMounted(() => addSignalListener(onNetworkFeaturesUpdated, storeId, updateStakeEnabledStatus));
    onUnmounted(() => removeSignalListener(onNetworkFeaturesUpdated, storeId));
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        ((_a = unref(appAccount)) == null ? void 0 : _a.data) ? (openBlock(), createElementBlock("div", _hoisted_2$1, [
          createVNode(_sfc_main$m, {
            label: unref(it)("wallet.settings.account.headline")
          }, null, 8, ["label"]),
          createVNode(_sfc_main$l, {
            text: unref(it)("wallet.settings.account.caption")
          }, null, 8, ["text"]),
          createVNode(GridSpace, { hr: "" }),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.accountName.label"),
            caption: unref(it)("wallet.settings.accountName.caption")
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$c, {
                class: "col-span-12 lg:ml-5",
                "prefilled-account-name": unref(name),
                "is-update": true,
                saving: unref(saving),
                onSubmit: onSubmitAccountName
              }, null, 8, ["prefilled-account-name", "saving"])
            ]),
            _: 1
          }, 8, ["label", "caption"]),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.exports.accountPub.label"),
            caption: unref(it)("wallet.settings.exports.accountPub.caption")
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$b, { class: "ml-5 pr-6" })
            ]),
            _: 1
          }, 8, ["label", "caption"]),
          unref(hasCatalystData) ? (openBlock(), createBlock(_sfc_main$p, {
            key: 0,
            label: unref(it)("wallet.settings.voterData.label"),
            caption: unref(it)("wallet.settings.voterData.caption"),
            "can-expand": true,
            "open-expanded": expandedVoterData.value,
            saving: unref(saving)
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$a, {
                "enc-catalyst-key": unref(catalystData),
                "force-show": expandedVoterData.value
              }, null, 8, ["enc-catalyst-key", "force-show"])
            ]),
            _: 1
          }, 8, ["label", "caption", "open-expanded", "saving"])) : createCommentVNode("", true),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.sam.account.label"),
            caption: unref(it)("wallet.settings.sam.global.caption"),
            "can-toggle": true,
            "can-expand": false,
            enabled: unref(isSamEnabled),
            saving: unref(saving),
            "show-apply-all": true,
            onToggle: onToggleSAM,
            onApplyAll: onApplySAMGlobal
          }, null, 8, ["label", "caption", "enabled", "saving"]),
          unref(isSamEnabled) ? (openBlock(), createBlock(_sfc_main$p, {
            key: 1,
            label: unref(it)("wallet.settings.sam.receiveaddress.label"),
            caption: unref(it)("wallet.settings.sam.receiveaddress.caption"),
            enabled: unref(isSamEnabled)
          }, {
            setting: withCtx(() => [
              createBaseVNode("div", _hoisted_3$1, [
                createVNode(_sfc_main$8, { onSaveSetting: onSubmitSAMAddress })
              ])
            ]),
            _: 1
          }, 8, ["label", "caption", "enabled"])) : createCommentVNode("", true),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.collateral.label"),
            caption: unref(it)("wallet.settings.collateral.caption"),
            "can-toggle": false,
            enabled: true,
            saving: unref(saving),
            "show-apply-all": false
          }, {
            setting: withCtx(() => [
              createBaseVNode("div", _hoisted_4$1, [
                createVNode(_sfc_main$7, { enabled: true })
              ])
            ]),
            _: 1
          }, 8, ["label", "caption", "saving"]),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.manualsync.label"),
            caption: unref(it)("wallet.settings.manualsync.caption"),
            "can-toggle": true,
            "can-expand": true,
            enabled: unref(isManualSyncEnabled),
            saving: unref(saving),
            "show-apply-all": true,
            onToggle: onToggleManualSync,
            onApplyAll: onApplyManualSync
          }, null, 8, ["label", "caption", "enabled", "saving"]),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.historysync.label"),
            caption: unref(it)("wallet.settings.historysync.caption"),
            "can-toggle": true,
            "can-expand": true,
            enabled: unref(isHistorySyncEnabled),
            saving: unref(saving),
            "show-apply-all": true,
            onToggle: onToggleHistorySync,
            onApplyAll: onApplyHistorySync
          }, null, 8, ["label", "caption", "enabled", "saving"]),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.tokenfrag.label"),
            caption: unref(it)("wallet.settings.tokenfrag.caption"),
            "can-toggle": true,
            enabled: unref(isTfEnabled),
            saving: unref(saving),
            "show-apply-all": true,
            onToggle: onToggleTF,
            onApplyAll: onApplyTF
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$6, {
                class: "lg:ml-5",
                onSaveSetting: onUpdateTFBundleSize
              })
            ]),
            _: 1
          }, 8, ["label", "caption", "enabled", "saving"]),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.advancedUTxOManagement.label"),
            caption: unref(it)("wallet.settings.advancedUTxOManagement.caption"),
            "can-toggle": true,
            "can-expand": true,
            enabled: unref(isAumEnabled),
            saving: unref(saving),
            "show-apply-all": true,
            onToggle: onToggleAUM,
            onApplyAll: onApplyAUM
          }, null, 8, ["label", "caption", "enabled", "saving"]),
          stakeIsEnabled.value ? (openBlock(), createBlock(_sfc_main$p, {
            key: 2,
            label: unref(it)("wallet.settings.withdrawal.label"),
            caption: unref(it)("wallet.settings.withdrawal.caption"),
            "can-toggle": true,
            "can-expand": true,
            enabled: unref(isAwEnabled),
            saving: unref(saving),
            "show-apply-all": true,
            onToggle: onToggleAW,
            onApplyAll: onApplyAW
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$l, {
                class: "lg:ml-5",
                text: unref(it)("wallet.settings.withdrawal.info")
              }, null, 8, ["text"])
            ]),
            _: 1
          }, 8, ["label", "caption", "enabled", "saving"])) : createCommentVNode("", true),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.sendall.label"),
            caption: unref(it)("wallet.settings.sendall.caption"),
            "can-toggle": true,
            "can-expand": true,
            enabled: unref(isSendAllEnabled),
            saving: unref(saving),
            "show-apply-all": true,
            onToggle: onToggleSendAll,
            onApplyAll: onApplySendAll
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$l, {
                class: "lg:ml-5",
                text: unref(it)("wallet.settings.sendall.info")
              }, null, 8, ["text"])
            ]),
            _: 1
          }, 8, ["label", "caption", "enabled", "saving"]),
          stakeIsEnabled.value ? (openBlock(), createBlock(_sfc_main$p, {
            key: 3,
            label: unref(it)("wallet.settings.dereg.headline")
          }, {
            setting: withCtx(() => [
              createBaseVNode("div", _hoisted_5, [
                createBaseVNode("div", _hoisted_6, toDisplayString(unref(it)("wallet.settings.deldereg.dangerzone")), 1),
                createVNode(GridSpace, { hr: "" }),
                createVNode(_sfc_main$5)
              ])
            ]),
            _: 1
          }, 8, ["label"])) : createCommentVNode("", true),
          stakeIsEnabled.value ? (openBlock(), createBlock(_sfc_main$p, {
            key: 4,
            label: unref(it)("wallet.settings.govdereg.headline")
          }, {
            setting: withCtx(() => [
              createBaseVNode("div", _hoisted_7, [
                createBaseVNode("div", _hoisted_8, toDisplayString(unref(it)("wallet.settings.deldereg.dangerzone")), 1),
                createVNode(GridSpace, { hr: "" }),
                createVNode(_sfc_main$4)
              ])
            ]),
            _: 1
          }, 8, ["label"])) : createCommentVNode("", true),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.walletEntity.label"),
            caption: unref(it)("wallet.settings.walletEntity.captionAccount")
          }, {
            setting: withCtx(() => [
              createVNode(_sfc_main$3, {
                class: "lg:ml-5",
                onSaveSetting: onUpdateTFBundleSize
              })
            ]),
            _: 1
          }, 8, ["label", "caption"])
        ])) : createCommentVNode("", true)
      ]);
    };
  }
});
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "DeleteWallet",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.deldereg.deletewallet" },
    fullWidth: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    useQuasar();
    const { t } = useTranslation();
    const { gotoHome } = useNavigation();
    const {
      selectedWalletId,
      walletSettings
    } = useSelectedAccount();
    const walletName = walletSettings.name;
    const toggled = ref(false);
    const isCorrectName = ref(false);
    const onDeleteWallet = async () => {
      const isCorrectName2 = walletName.value && searchInput.value === walletName.value;
      if (isCorrectName2 && toggled.value) {
        await deleteWallet(selectedWalletId.value);
        await loadWalletList();
        gotoHome();
      }
      if (!isCorrectName2) {
        searchInputError.value = t(props.textId + ".name.error");
      }
      toggleError.value = !toggled.value;
    };
    const searchInput = ref("");
    const searchInputError = ref("");
    const searchDisabled = ref(false);
    const toggleError = ref(false);
    function validateSearchInput() {
      if (walletName.value) {
        isCorrectName.value = searchInput.value.trim() === walletName.value.trim();
        if (!isCorrectName.value && searchInput.value !== "") {
          searchInputError.value = t(props.textId + ".name.error");
        } else {
          searchInputError.value = "";
        }
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
        searchInputError.value = "";
      }
      searchDisabled.value = !toggled.value;
    });
    watch(searchInput, () => {
      validateSearchInput();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["w-full col-span-12 grid grid-cols-12 cc-gap", __props.fullWidth ? "" : "lg:col-span-6"])
      }, [
        createVNode(_sfc_main$m, {
          label: unref(t)(__props.textId + ".headline")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$l, {
          text: unref(t)(__props.textId + ".caption")
        }, null, 8, ["text"]),
        createVNode(_sfc_main$y, {
          label: unref(t)(__props.textId + ".toggle.acknowledged.label"),
          text: unref(t)(__props.textId + ".toggle.acknowledged.text"),
          icon: unref(t)(__props.textId + ".toggle.acknowledged.icon"),
          toggled: toggled.value,
          toggleError: toggleError.value,
          "onUpdate:toggled": _cache[0] || (_cache[0] = ($event) => toggled.value = $event),
          class: "col-span-12"
        }, null, 8, ["label", "text", "icon", "toggled", "toggleError"]),
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
          onReset: _cache[4] || (_cache[4] = ($event) => onReset()),
          label: unref(t)(__props.textId + ".name.label"),
          "input-hint": unref(t)(__props.textId + ".name.hint"),
          "input-info": unref(t)(__props.textId + ".name.info"),
          alwaysShowInfo: false,
          "input-id": "searchInput",
          "input-type": "text",
          autocomplete: "name",
          inputDisabled: searchDisabled.value,
          "show-reset": true,
          "dense-input": ""
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error", "label", "input-hint", "input-info", "inputDisabled"]),
        createVNode(_sfc_main$z, {
          class: normalizeClass(__props.fullWidth ? "col-span-12" : "col-span-12 xs:col-span-8 lg:col-span-9"),
          link: onDeleteWallet,
          disabled: !toggled.value || !isCorrectName.value,
          label: unref(t)(__props.textId + ".button.delete.label"),
          icon: unref(t)(__props.textId + ".button.delete.icon")
        }, null, 8, ["class", "disabled", "label", "icon"])
      ], 2);
    };
  }
});
const _hoisted_1 = { class: "cc-grid cc-text-sz dark:text-cc-gray" };
const _hoisted_2 = { class: "cc-grid" };
const _hoisted_3 = { class: "col-span-12 lg:ml-6 p-2 grid grid-cols-12 cc-gap cc-rounded cc-ring-red mb-2" };
const _hoisted_4 = { class: "col-span-12 flex flex-row flex-nowrap justify-center items-center whitespace-pre-wrap cc-text-bold cc-text-red-light" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "SettingsDangerZone",
  setup(__props) {
    const { it } = useTranslation();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          createVNode(_sfc_main$m, {
            label: unref(it)("wallet.settings.deldereg.dangerzone")
          }, null, 8, ["label"]),
          createVNode(GridSpace, { hr: "" }),
          createVNode(_sfc_main$p, {
            label: unref(it)("wallet.settings.deldereg.headline")
          }, {
            setting: withCtx(() => [
              createBaseVNode("div", _hoisted_3, [
                createBaseVNode("div", _hoisted_4, toDisplayString(unref(it)("wallet.settings.deldereg.dangerzone")), 1),
                createVNode(GridSpace, { hr: "" }),
                createVNode(_sfc_main$1, { "full-width": "" })
              ])
            ]),
            _: 1
          }, 8, ["label"])
        ])
      ]);
    };
  }
});
export {
  _sfc_main$2 as _,
  _sfc_main$e as a,
  _sfc_main as b
};
