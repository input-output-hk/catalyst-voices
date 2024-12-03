import { o as isCatalystEnabled, p as isGovernanceEnabled } from "./NetworkId.js";
import { gE as endPoints, L as api, d as defineComponent, ct as onErrorCaptured, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, j as createCommentVNode, q as createVNode, h as withCtx, i as createTextVNode, u as unref, z as ref, f as computed, H as Fragment, I as renderList, a as createBlock, aH as QPagination_default, n as normalizeClass, C as onMounted, D as watch, V as nextTick, gF as isSameArray, aA as renderSlot, B as useFormatter, S as reactive, a7 as useQuasar, K as networkId, gG as getResultsDate, gH as isValidDate, a2 as now, aW as addSignalListener, gI as onTxSubmitted, aG as onUnmounted, aX as removeSignalListener, b as withModifiers, a0 as isMobileApp, bN as isIosApp, bR as isAndroidApp, cf as getRandomId, ae as useSelectedAccount, gJ as generateCatalystKey, bE as getDataSignErrorMsg, bD as ErrorSignData, gK as onBuiltTxVoteReg, g3 as getTxBuiltErrorMsg, f_ as ErrorBuildTx, bm as dispatchSignal, gL as doBuildTxVoteReg, es as getRequestData, et as ApiRequestType, eu as ErrorSync, ev as DEFAULT_ACCOUNT_ID, gM as getDRepAddressFromKeyHash, gN as getDRepAddressFromKeyHashOld, c3 as isZero, cZ as multiply, cI as divide, gO as getCCColdAddressFromKeyHash, gP as getCCColdAddressFromKeyHashOld, gQ as getCCHotAddressFromKeyHash, gR as getCCHotAddressFromKeyHashOld, gS as onEpochParamsUpdated, gT as epochParams, gU as getIAppAccountById, gV as decodeBech32, gW as onBuiltTxVoteDelegation, gX as doBuildTxVoteDelegation, aQ as onNetworkFeaturesUpdated } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useAdaSymbol } from "./useAdaSymbol.js";
import { _ as _sfc_main$l, u as useKeystoneDevice } from "./Keystone.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$j } from "./ExternalLink.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$c } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$d } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { b as browser } from "./browser.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { I as IconCheck } from "./IconCheck.js";
import { I as IconInfo } from "./IconInfo.js";
import { I as IconError } from "./IconError.js";
import { _ as _sfc_main$e, a as _sfc_main$f } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$g } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$h } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { I as IconWarning } from "./IconWarning.js";
import { _ as _sfc_main$m } from "./GridSteps.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$k } from "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$i } from "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
import { d as doOpenWalletSettings } from "./signals.js";
import { I as IconPencil } from "./IconPencil.js";
import { _ as _sfc_main$o } from "./GridTxListUtxoListBadges.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$p } from "./SendWalletList.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$n } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$q } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./useNavigation.js";
import "./useTabId.js";
import "./ReportLabelNewModal.vue_vue_type_script_setup_true_lang.js";
import "./AccountItemBalance.vue_vue_type_script_setup_true_lang.js";
const voting_power_threshold = 0;
const overrideDefaults = (catalystData) => {
  catalystData.voting_power_threshold = voting_power_threshold;
  if ("chain_vote_plans" in catalystData) {
    delete catalystData.chain_vote_plans;
  }
};
const getCatalystData = async (networkId2) => {
  try {
    return await pullLatestCatalystData(networkId2);
  } catch (error) {
    console.error("getCatalystData:", error.message);
  }
  return null;
};
const pullLatestCatalystData = async (networkId2) => {
  var _a;
  const url = (_a = endPoints[networkId2]) == null ? void 0 : _a.catalyst;
  if (!url) {
    return null;
  }
  const catalystData = await api.get(url).catch((err) => {
    console.error("pullLatestCatalystData:", err);
    return null;
  });
  if (catalystData) {
    overrideDefaults(catalystData);
    return catalystData;
  }
  return null;
};
function info() {
  return {
    getCatalystData
  };
}
const _hoisted_1$b = { class: "relative cc-area-light cc-text-sz flex-1 w-full inline-flex flex-col flex-nowrap justify-start items-start" };
const _hoisted_2$6 = { class: "relative w-full h-full" };
const _hoisted_3$6 = { class: "h-full flex flex-col items-stretch overflow-hidden cc-p" };
const _hoisted_4$4 = { class: "flex flex-row flex-nowrap items-start justify-between" };
const _hoisted_5$2 = { class: "flex flex-row flex-nowrap" };
const _hoisted_6$2 = { class: "item-text cc-text-semi-bold break-words" };
const _hoisted_7$2 = {
  key: 0,
  class: "h-5 cc-badge-blue whitespace-nowrap mx-2"
};
const _hoisted_8$2 = {
  key: 0,
  class: "badge-social cc-flex-fixed"
};
const _hoisted_9$2 = ["href"];
const _hoisted_10$2 = { class: "text-xs break-words" };
const _hoisted_11$2 = { class: "flex flex-grow items-end mt-2 text-xs" };
const _hoisted_12$1 = { class: "cc-text-semi-bold whitespace-nowrap mr-2" };
const _sfc_main$b = /* @__PURE__ */ defineComponent({
  __name: "GridFundChallenge",
  props: {
    challenge: { type: Object, required: true }
  },
  setup(__props) {
    const { t } = useTranslation();
    onErrorCaptured((e) => {
      console.error("Wallet: GridFundChallenge: onErrorCaptured", e);
      return true;
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$b, [
        createBaseVNode("div", _hoisted_2$6, [
          createBaseVNode("div", _hoisted_3$6, [
            createBaseVNode("div", _hoisted_4$4, [
              createBaseVNode("div", _hoisted_5$2, [
                createBaseVNode("span", _hoisted_6$2, toDisplayString(__props.challenge.title), 1),
                __props.challenge.challenge_type !== "simple" ? (openBlock(), createElementBlock("div", _hoisted_7$2, toDisplayString(__props.challenge.challenge_type), 1)) : createCommentVNode("", true)
              ]),
              __props.challenge.challenge_url ? (openBlock(), createElementBlock("div", _hoisted_8$2, [
                createVNode(_sfc_main$c, {
                  "tooltip-c-s-s": "whitespace-nowrap",
                  offset: [0, -44],
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(t)("wallet.voting.catalyst.step.info.fund.challenges.link")), 1)
                  ]),
                  _: 1
                }),
                createBaseVNode("a", {
                  href: __props.challenge.challenge_url,
                  target: "_blank",
                  rel: "noopener noreferrer"
                }, _cache[0] || (_cache[0] = [
                  createBaseVNode("i", { class: "mdi mdi-web text-blue-500" }, null, -1)
                ]), 8, _hoisted_9$2)
              ])) : createCommentVNode("", true)
            ]),
            createVNode(GridSpace, {
              hr: "",
              class: "py-1"
            }),
            createBaseVNode("div", _hoisted_10$2, toDisplayString(__props.challenge.description), 1),
            createBaseVNode("div", _hoisted_11$2, [
              createBaseVNode("span", _hoisted_12$1, toDisplayString(unref(t)("wallet.voting.catalyst.step.info.fund.challenges.allocation")), 1),
              createVNode(_sfc_main$d, {
                amount: __props.challenge.rewards_total.toString(),
                currency: "USD",
                "is-whole-number": "",
                decimals: 0
              }, null, 8, ["amount"])
            ])
          ])
        ])
      ]);
    };
  }
});
const _hoisted_1$a = { class: "col-span-12 flex justify-center" };
const itemsOnPage = 12;
const _sfc_main$a = /* @__PURE__ */ defineComponent({
  __name: "GridFundChallengeList",
  props: {
    challengeList: { type: Array, required: true },
    dense: { type: Boolean, default: false }
  },
  setup(__props) {
    const props = __props;
    const currentPage = ref(1);
    const showPagination = computed(() => props.challengeList.length > itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const maxPages = computed(() => Math.ceil(props.challengeList.length / itemsOnPage));
    const challengeListFiltered = computed(() => props.challengeList.slice(currentPageStart.value, currentPageStart.value + itemsOnPage));
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(challengeListFiltered.value, (challenge) => {
          return openBlock(), createBlock(_sfc_main$b, {
            class: normalizeClass(__props.dense ? "col-span-12 sm:col-span-6" : "col-span-12"),
            key: challenge.id,
            challenge
          }, null, 8, ["class", "challenge"]);
        }), 128)),
        showPagination.value ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          class: "mt-0.5"
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_1$a, [
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
        ])
      ], 64);
    };
  }
});
const _sfc_main$9 = {};
const _hoisted_1$9 = {
  stroke: "none",
  viewBox: "0 0 24 24",
  fill: "currentColor",
  "aria-hidden": "true"
};
function _sfc_render$1(_ctx, _cache) {
  return openBlock(), createElementBlock("svg", _hoisted_1$9, _cache[0] || (_cache[0] = [
    createBaseVNode("path", {
      fill: "currentColor",
      d: "M18.71,19.5C17.88,20.74 17,21.95 15.66,21.97C14.32,22 13.89,21.18 12.37,21.18C10.84,21.18 10.37,21.95 9.1,22C7.79,22.05 6.8,20.68 5.96,19.47C4.25,17 2.94,12.45 4.7,9.39C5.57,7.87 7.13,6.91 8.82,6.88C10.1,6.86 11.32,7.75 12.11,7.75C12.89,7.75 14.37,6.68 15.92,6.84C16.57,6.87 18.39,7.1 19.56,8.82C19.47,8.88 17.39,10.1 17.41,12.63C17.44,15.65 20.06,16.66 20.09,16.67C20.06,16.74 19.67,18.11 18.71,19.5M13,3.5C13.73,2.67 14.94,2.04 15.94,2C16.07,3.17 15.6,4.35 14.9,5.19C14.21,6.04 13.07,6.7 11.95,6.61C11.8,5.46 12.36,4.26 13,3.5Z"
    }, null, -1)
  ]));
}
const AppleLogo = /* @__PURE__ */ _export_sfc(_sfc_main$9, [["render", _sfc_render$1]]);
const _sfc_main$8 = {};
const _hoisted_1$8 = {
  stroke: "none",
  viewBox: "0 0 24 24",
  fill: "currentColor",
  "aria-hidden": "true"
};
function _sfc_render(_ctx, _cache) {
  return openBlock(), createElementBlock("svg", _hoisted_1$8, _cache[0] || (_cache[0] = [
    createBaseVNode("path", {
      fill: "currentColor",
      d: "M16.61 15.15C16.15 15.15 15.77 14.78 15.77 14.32S16.15 13.5 16.61 13.5H16.61C17.07 13.5 17.45 13.86 17.45 14.32C17.45 14.78 17.07 15.15 16.61 15.15M7.41 15.15C6.95 15.15 6.57 14.78 6.57 14.32C6.57 13.86 6.95 13.5 7.41 13.5H7.41C7.87 13.5 8.24 13.86 8.24 14.32C8.24 14.78 7.87 15.15 7.41 15.15M16.91 10.14L18.58 7.26C18.67 7.09 18.61 6.88 18.45 6.79C18.28 6.69 18.07 6.75 18 6.92L16.29 9.83C14.95 9.22 13.5 8.9 12 8.91C10.47 8.91 9 9.24 7.73 9.82L6.04 6.91C5.95 6.74 5.74 6.68 5.57 6.78C5.4 6.87 5.35 7.08 5.44 7.25L7.1 10.13C4.25 11.69 2.29 14.58 2 18H22C21.72 14.59 19.77 11.7 16.91 10.14H16.91Z"
    }, null, -1)
  ]));
}
const AndroidLogo = /* @__PURE__ */ _export_sfc(_sfc_main$8, [["render", _sfc_render]]);
const _hoisted_1$7 = { class: "flex flex-col mx-4 lg:mx-12" };
const _hoisted_2$5 = ["href"];
const _hoisted_3$5 = { class: "flex flex-row flex-nowrap justify-center items-center mt-1 mb-4" };
const _hoisted_4$3 = ["src", "alt"];
const _sfc_main$7 = /* @__PURE__ */ defineComponent({
  __name: "CatalystApp",
  props: {
    textId: { type: String, required: true, default: "" },
    company: { type: String, required: true, default: "" }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const qrImage = ref("");
    const generateQRcode = async () => {
      try {
        qrImage.value = await browser.toDataURL(t(props.textId + ".url"));
      } catch (err) {
        console.error(err);
      }
    };
    onMounted(() => {
      generateQRcode();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$7, [
        createBaseVNode("a", {
          class: "break-all text-center cc-text-semi-bold cursor-pointer",
          href: unref(t)(__props.textId + ".url"),
          target: "_blank",
          rel: "noopener noreferrer"
        }, [
          createBaseVNode("div", _hoisted_3$5, [
            __props.company === "apple" ? (openBlock(), createBlock(AppleLogo, {
              key: 0,
              class: "h-6 w-6 pr-1"
            })) : createCommentVNode("", true),
            __props.company === "android" ? (openBlock(), createBlock(AndroidLogo, {
              key: 1,
              class: "h-6 w-6 pr-1"
            })) : createCommentVNode("", true),
            createTextVNode(" " + toDisplayString(unref(t)(__props.textId + ".label")), 1)
          ]),
          createBaseVNode("img", {
            class: "w-48 h-48 cc-shadow cc-rounded",
            loading: "lazy",
            src: qrImage.value,
            alt: unref(t)(__props.textId + ".label")
          }, null, 8, _hoisted_4$3)
        ], 8, _hoisted_2$5)
      ]);
    };
  }
});
const _hoisted_1$6 = { class: "col-span-12 flex flex-col md:flex-row lg:flex-col xl:flex-row items-center justify-center md:justify-start lg:justify-center xl:justify-start" };
const _hoisted_2$4 = { class: "w-full grid grid-cols-12 max-w-md" };
const _hoisted_3$4 = {
  key: 0,
  class: "flex flex-row flex-nowrap items-center pt-3 md:pt-0 lg:pt-3 xl:pt-0 md:ml-4 lg:ml-0 xl:ml-4"
};
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "PinInput",
  props: {
    textId: { type: String, required: true, default: "" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { t } = useTranslation();
    const pin1 = ref(null);
    const pin2 = ref(null);
    const pin3 = ref(null);
    const pin4 = ref(null);
    const pin1Input = ref("");
    const pin2Input = ref("");
    const pin3Input = ref("");
    const pin4Input = ref("");
    const pinCode = ref([]);
    const pinError = ref(false);
    const validPIN = computed(() => pin1Input.value && pin2Input.value && pin3Input.value && pin4Input.value);
    watch(() => validPIN.value, () => {
      nextTick(() => {
        confirmPin();
      });
    });
    function validatePINInput(value) {
      value = value.replace(/[^0-9]/g, "");
      if (value.length === 0) {
        return "";
      }
      return value.charAt(value.length - 1);
    }
    function validatePIN1Input(value) {
      var _a;
      if (value == void 0) {
        return;
      }
      pin1Input.value = validatePINInput(value);
      (_a = pin2.value) == null ? void 0 : _a.setFocus();
    }
    function validatePIN2Input(value) {
      var _a;
      if (value == void 0) {
        return;
      }
      pin2Input.value = validatePINInput(value);
      (_a = pin3.value) == null ? void 0 : _a.setFocus();
    }
    function validatePIN3Input(value) {
      var _a;
      if (value == void 0) {
        return;
      }
      pin3Input.value = validatePINInput(value);
      (_a = pin4.value) == null ? void 0 : _a.setFocus();
    }
    function validatePIN4Input(value) {
      if (value == void 0) {
        return;
      }
      pin4Input.value = validatePINInput(value);
    }
    const getPinArray = () => [
      Number(pin1Input.value),
      Number(pin2Input.value),
      Number(pin3Input.value),
      Number(pin4Input.value)
    ];
    function confirmPin() {
      var _a, _b;
      if (!validPIN.value) {
        return false;
      }
      if (pinCode.value.length === 0) {
        pinError.value = false;
        pinCode.value.push(...getPinArray());
        pin1Input.value = "";
        pin2Input.value = "";
        pin3Input.value = "";
        pin4Input.value = "";
        (_a = pin1.value) == null ? void 0 : _a.setFocus();
        return false;
      } else if (!isSameArray(pinCode.value, getPinArray())) {
        pinCode.value.splice(0);
        pin1Input.value = "";
        pin2Input.value = "";
        pin3Input.value = "";
        pin4Input.value = "";
        (_b = pin1.value) == null ? void 0 : _b.setFocus();
        pinError.value = true;
        return false;
      }
      return true;
    }
    function onSubmit() {
      if (!confirmPin()) {
        return;
      }
      emit("submit", pinCode.value);
    }
    onMounted(() => {
      var _a;
      return (_a = pin1.value) == null ? void 0 : _a.setFocus();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(_sfc_main$e, {
          label: unref(t)(__props.textId + ".header"),
          class: "col-span-12"
        }, null, 8, ["label"]),
        createVNode(_sfc_main$f, {
          text: unref(t)(__props.textId + ".caption"),
          class: "col-span-12 cc-text-sz"
        }, null, 8, ["text"]),
        createVNode(_sfc_main$g, {
          text: unref(t)(__props.textId + ".warning"),
          icon: "mdi mdi-alert-octagon-outline",
          class: "col-span-12 mb-2",
          "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
          css: "cc-rounded cc-banner-warning"
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12 my-0.5 sm:my-2"
        }),
        createBaseVNode("div", _hoisted_1$6, [
          createBaseVNode("div", _hoisted_2$4, [
            createVNode(GridInput, {
              "input-text": pin1Input.value,
              "onUpdate:inputText": [
                _cache[0] || (_cache[0] = ($event) => pin1Input.value = $event),
                validatePIN1Input
              ],
              class: "col-span-3",
              ref_key: "pin1",
              ref: pin1,
              onLostFocus: validatePIN1Input,
              onEnter: onSubmit,
              "input-hint": unref(t)(__props.textId + ".hint"),
              alwaysShowInfo: false,
              showReset: false,
              "input-text-c-s-s": "text-center",
              "input-c-s-s": "cc-input mr-3",
              "input-id": "pin1Input",
              "input-type": "text",
              autocomplete: "off"
            }, null, 8, ["input-text", "input-hint"]),
            createVNode(GridInput, {
              "input-text": pin2Input.value,
              "onUpdate:inputText": [
                _cache[1] || (_cache[1] = ($event) => pin2Input.value = $event),
                validatePIN2Input
              ],
              class: "col-span-3",
              ref_key: "pin2",
              ref: pin2,
              onLostFocus: validatePIN2Input,
              onEnter: onSubmit,
              "input-hint": unref(t)(__props.textId + ".hint"),
              alwaysShowInfo: false,
              showReset: false,
              "input-text-c-s-s": "text-center",
              "input-c-s-s": "cc-input ml-1 mr-2",
              "input-id": "pin2Input",
              "input-type": "text",
              autocomplete: "off"
            }, null, 8, ["input-text", "input-hint"]),
            createVNode(GridInput, {
              "input-text": pin3Input.value,
              "onUpdate:inputText": [
                _cache[2] || (_cache[2] = ($event) => pin3Input.value = $event),
                validatePIN3Input
              ],
              class: "col-span-3",
              ref_key: "pin3",
              ref: pin3,
              onLostFocus: validatePIN3Input,
              onEnter: onSubmit,
              "input-hint": unref(t)(__props.textId + ".hint"),
              alwaysShowInfo: false,
              showReset: false,
              "input-text-c-s-s": "text-center",
              "input-c-s-s": "cc-input ml-2 mr-1",
              "input-id": "pin3Input",
              "input-type": "text",
              autocomplete: "off"
            }, null, 8, ["input-text", "input-hint"]),
            createVNode(GridInput, {
              "input-text": pin4Input.value,
              "onUpdate:inputText": [
                _cache[3] || (_cache[3] = ($event) => pin4Input.value = $event),
                validatePIN4Input
              ],
              class: "col-span-3",
              ref_key: "pin4",
              ref: pin4,
              onLostFocus: validatePIN4Input,
              onEnter: onSubmit,
              "input-hint": unref(t)(__props.textId + ".hint"),
              alwaysShowInfo: false,
              showReset: false,
              "input-text-c-s-s": "text-center",
              "input-c-s-s": "cc-input ml-3",
              "input-id": "pin4Input",
              "input-type": "text",
              autocomplete: "off"
            }, null, 8, ["input-text", "input-hint"])
          ]),
          pinCode.value.length > 0 || pinError.value ? (openBlock(), createElementBlock("div", _hoisted_3$4, [
            validPIN.value && !pinError.value ? (openBlock(), createBlock(IconCheck, {
              key: 0,
              class: "w-7 flex-none text-green-600"
            })) : createCommentVNode("", true),
            pinError.value ? (openBlock(), createBlock(IconError, {
              key: 1,
              class: "w-7 flex-none mr-2"
            })) : createCommentVNode("", true),
            !validPIN.value && !pinError.value ? (openBlock(), createBlock(IconInfo, {
              key: 2,
              class: "w-7 flex-none mr-2"
            })) : createCommentVNode("", true),
            !validPIN.value ? (openBlock(), createBlock(_sfc_main$f, {
              key: 3,
              text: unref(t)(__props.textId + (pinError.value ? ".confirmError" : ".confirm")),
              class: "cc-text-sz"
            }, null, 8, ["text"])) : createCommentVNode("", true)
          ])) : createCommentVNode("", true)
        ]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12 my-0 mt-2"
        }),
        renderSlot(_ctx.$slots, "btnBack"),
        createVNode(_sfc_main$h, {
          label: unref(t)(__props.textId + ".button.next"),
          link: onSubmit,
          disabled: !validPIN.value || pinError.value,
          class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
        }, null, 8, ["label", "disabled"])
      ], 64);
    };
  }
});
const _hoisted_1$5 = {
  class: "w-5 top-5 absolute inset-0 flex justify-center",
  "aria-hidden": "true"
};
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "TimelineLine",
  props: {
    active: { type: Boolean, default: false }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$5, [
        createBaseVNode("div", {
          class: normalizeClass(["w-0.5 h-full", __props.active ? "cc-bg-highlight" : "cc-bg-inactive"])
        }, null, 2)
      ]);
    };
  }
});
const _hoisted_1$4 = { class: "relative ml-4 flex flex-col" };
const _hoisted_2$3 = { class: "absolute -top-0.5 lg:-top-1 cc-text-semi-bold" };
const _hoisted_3$3 = { class: "mt-5 font-mono" };
const _hoisted_4$2 = {
  key: 0,
  class: "mt-1 text-sm text-gray-400"
};
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "TimelineButton",
  props: {
    status: { type: String, default: "upcoming" },
    item: { type: Object, required: true },
    last: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const { formatDatetime } = useFormatter();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        !__props.last ? (openBlock(), createBlock(_sfc_main$5, {
          key: 0,
          active: __props.status === "complete"
        }, null, 8, ["active"])) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: normalizeClass(["relative w-5 h-5 rounded-full flex flex-row flex-nowrap items-center cc-text-sz", __props.status === "complete" ? "cc-bg-highlight " : "bg-white border-2 " + (__props.status === "current" ? "cc-border-highlight " : "cc-border-inactive ")])
        }, [
          __props.status === "complete" ? (openBlock(), createBlock(IconCheck, {
            key: 0,
            class: "w-5 h-5 text-white",
            "aria-hidden": "true"
          })) : (openBlock(), createElementBlock("span", {
            key: 1,
            class: normalizeClass(["ml-1 h-2 w-2 rounded-full", __props.status === "current" ? "cc-bg-highlight" : "bg-transparent"]),
            "aria-hidden": "true"
          }, null, 2))
        ], 2),
        createBaseVNode("div", _hoisted_1$4, [
          createBaseVNode("span", _hoisted_2$3, toDisplayString(__props.item.label), 1),
          createBaseVNode("span", _hoisted_3$3, toDisplayString(unref(formatDatetime)(__props.item.date, true, __props.item.time)), 1),
          __props.item.caption.length > 0 ? (openBlock(), createElementBlock("span", _hoisted_4$2, toDisplayString(__props.item.caption), 1)) : createCommentVNode("", true)
        ])
      ], 64);
    };
  }
});
const _hoisted_1$3 = { class: "relative col-span-12 grid grid-cols-12 cc-gap cc-text-sz mt-3 md:mt-4" };
const _hoisted_2$2 = {
  "aria-label": "Progress",
  class: "col-span-12 inline-flex justify-start"
};
const _hoisted_3$2 = { class: "flex flex-col items-start justify-start" };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "GridTimeline",
  props: {
    steps: { type: Array, required: true },
    currentStep: { type: Number, required: true, default: 0 },
    stepperCSS: { type: String, required: false, default: "" }
  },
  setup(__props) {
    const props = __props;
    const internalSteps = reactive([]);
    let index = 0;
    for (const step of props.steps) {
      if (index < props.currentStep) {
        internalSteps.push({ option: step, status: "complete" });
      } else if (index === props.currentStep) {
        internalSteps.push({ option: step, status: "current" });
      } else {
        internalSteps.push({ option: step, status: "upcoming" });
      }
      index++;
    }
    const stepIndex = ref(0);
    watch(() => props.currentStep, () => {
      stepIndex.value = props.currentStep;
      index = 0;
      for (const step of internalSteps) {
        if (index < stepIndex.value) {
          step.status = "complete";
        } else if (index === stepIndex.value) {
          step.status = "current";
        } else {
          step.status = "upcoming";
        }
        index++;
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$3, [
        createBaseVNode("nav", _hoisted_2$2, [
          createBaseVNode("ol", _hoisted_3$2, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(internalSteps, (step, stepIdx) => {
              return openBlock(), createElementBlock("li", {
                key: step.option.id,
                class: normalizeClass(["relative flex flex-row items-start", __props.stepperCSS])
              }, [
                createVNode(_sfc_main$4, {
                  status: step.status,
                  item: step.option,
                  last: stepIdx === internalSteps.length - 1
                }, null, 8, ["status", "item", "last"])
              ], 2);
            }), 128))
          ])
        ])
      ]);
    };
  }
});
const _hoisted_1$2 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg" };
const _hoisted_2$1 = { class: "col-span-12 sm:col-span-6 2xl:col-span-3 cc-rounded cc-shadow cc-bg-light-0 cc-p" };
const _hoisted_3$1 = { class: "col-span-12 sm:col-span-6 2xl:col-span-3 cc-rounded cc-shadow cc-bg-light-0 cc-p" };
const _hoisted_4$1 = { class: "col-span-12 sm:col-span-6 2xl:col-span-3 cc-rounded cc-shadow cc-bg-light-0 cc-p" };
const _hoisted_5$1 = { class: "col-span-12 sm:col-span-6 2xl:col-span-3 cc-rounded cc-shadow cc-bg-light-0 cc-p" };
const _hoisted_6$1 = {
  key: 2,
  class: "col-span-12"
};
const _hoisted_7$1 = {
  key: 1,
  class: "grid grid-cols-12 cc-gap-lg"
};
const _hoisted_8$1 = { class: "cc-text-semi-bold" };
const _hoisted_9$1 = { class: "col-span-12 flex flex-row cc-gap-lg items-center justify-center" };
const _hoisted_10$1 = { class: "col-span-12 flex flex-row flex-nowrap items-center" };
const _hoisted_11$1 = {
  key: 0,
  class: "col-span-12 flex flex-row flex-nowrap items-center"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "Catalyst",
  setup(__props) {
    onErrorCaptured((e) => {
      console.error("Voting: onErrorCaptured", e);
      return true;
    });
    const storeId = "Voting" + getRandomId();
    const {
      walletData,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const rewardInfo = accountSettings.rewardInfo;
    const setCatalystCIP15Key = accountSettings.setCatalystCIP15Key;
    const { t } = useTranslation();
    const $q = useQuasar();
    const { adaSymbol } = useAdaSymbol();
    const {
      createKeystoneCatalystRequest,
      handleKeystoneCatalyst
    } = useKeystoneDevice();
    const currentStep = ref(0);
    const pinCode = ref([]);
    const catalystKey = ref(null);
    const showChallenges = ref(false);
    const catalystData = ref(null);
    const isLoading = ref(true);
    const { getCatalystData: getCatalystData2 } = info();
    const votingPreReqError = ref("");
    const votingError = ref("");
    const hasSubmitError = ref(false);
    const timelineItems = reactive([]);
    const isKeystone = computed(() => !!accountData.value && accountData.value.account.signType === "keystone");
    const keystoneUR = ref();
    onMounted(async () => {
      catalystData.value = await getCatalystData2(networkId.value);
      if (catalystData.value) {
        loadVotingSchedule();
      }
      isLoading.value = false;
      votingPrerequisites();
    });
    const currentTimelineItem = ref(0);
    const isNextFund = computed(() => {
      const resultsDate = getResultsDate(catalystData.value);
      return isValidDate(resultsDate) && now() > new Date(resultsDate).getTime();
    });
    function loadVotingSchedule() {
      var _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k;
      timelineItems.splice(0);
      let resultsDate = getResultsDate(catalystData.value);
      let snapshotDate = "TBD";
      let votestartDate = "TBD";
      let voteendDate = "TBD";
      if (isValidDate(resultsDate) && now() > new Date(resultsDate).getTime()) {
        resultsDate = "TBD";
        if (isValidDate((_a = catalystData.value) == null ? void 0 : _a.next.snapshot_start)) {
          snapshotDate = catalystData.value.next.snapshot_start;
        } else if (isValidDate((_b = catalystData.value) == null ? void 0 : _b.next_registration_snapshot_time)) {
          snapshotDate = catalystData.value.next_registration_snapshot_time;
        }
        if (isValidDate((_c = catalystData.value) == null ? void 0 : _c.next.voting_start)) {
          votestartDate = catalystData.value.next.voting_start;
        } else if (isValidDate((_d = catalystData.value) == null ? void 0 : _d.next_fund_start_time)) {
          votestartDate = catalystData.value.next_fund_start_time;
        }
        if (isValidDate((_e = catalystData.value) == null ? void 0 : _e.next.voting_end)) {
          voteendDate = catalystData.value.next.voting_end;
        }
      } else {
        if (isValidDate((_f = catalystData.value) == null ? void 0 : _f.registration_snapshot_time)) {
          snapshotDate = catalystData.value.registration_snapshot_time;
        } else if (isValidDate((_g = catalystData.value) == null ? void 0 : _g.snapshot_start)) {
          snapshotDate = catalystData.value.snapshot_start;
        }
        if (isValidDate((_h = catalystData.value) == null ? void 0 : _h.fund_start_time)) {
          votestartDate = catalystData.value.fund_start_time;
        } else if (isValidDate((_i = catalystData.value) == null ? void 0 : _i.voting_start)) {
          votestartDate = catalystData.value.voting_start;
        }
        if (isValidDate((_j = catalystData.value) == null ? void 0 : _j.fund_end_time)) {
          voteendDate = catalystData.value.fund_end_time;
        } else if (isValidDate((_k = catalystData.value) == null ? void 0 : _k.voting_end)) {
          voteendDate = catalystData.value.voting_end;
        }
      }
      timelineItems.push(
        {
          id: "snapshot",
          date: snapshotDate,
          time: true,
          label: t("wallet.voting.catalyst.step.info.fund.timeline.snapshot.label"),
          caption: t("wallet.voting.catalyst.step.info.fund.timeline.snapshot.caption")
        },
        {
          id: "votestart",
          date: votestartDate,
          time: true,
          label: t("wallet.voting.catalyst.step.info.fund.timeline.votestart.label"),
          caption: t("wallet.voting.catalyst.step.info.fund.timeline.votestart.caption")
        },
        {
          id: "voteend",
          date: voteendDate,
          time: true,
          label: t("wallet.voting.catalyst.step.info.fund.timeline.voteend.label"),
          caption: t("wallet.voting.catalyst.step.info.fund.timeline.voteend.caption")
        },
        {
          id: "result",
          date: resultsDate,
          time: false,
          label: t("wallet.voting.catalyst.step.info.fund.timeline.result.label"),
          caption: isValidDate(resultsDate) ? t("wallet.voting.catalyst.step.info.fund.timeline.result.caption") : ""
        }
      );
      for (const item of timelineItems) {
        try {
          if (now() >= new Date(item.date).getTime()) {
            currentTimelineItem.value++;
          }
        } catch (e) {
          break;
        }
      }
    }
    const optionsSteps = reactive([
      { id: "info", label: t("wallet.voting.catalyst.step.stepper.info") },
      { id: "app", label: t("wallet.voting.catalyst.step.stepper.app") },
      { id: "pin", label: t("wallet.voting.catalyst.step.stepper.pin") },
      { id: "tx", label: t("wallet.voting.catalyst.step.stepper.tx") }
    ]);
    function goBack() {
      if (currentStep.value === 1) {
        currentStep.value = 0;
      } else if (currentStep.value === 2) {
        currentStep.value = 1;
      } else if (currentStep.value === 3) {
        currentStep.value = 2;
      }
    }
    const showWarningModal = ref({ display: false });
    const confirmSnapshot = () => {
      showWarningModal.value.display = false;
      currentStep.value = 1;
    };
    async function gotoNext() {
      if (currentStep.value === 0) {
        currentStep.value = 1;
      } else if (currentStep.value === 1) {
        currentStep.value = 2;
      } else if (currentStep.value === 2) {
        currentStep.value = 3;
      } else if (currentStep.value === 3) {
        voteRegistration();
      }
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
          message: t("wallet.keystone.ok"),
          position: "top-left"
        });
        if (keystoneSignResolve) {
          keystoneSignResolve(handleKeystoneCatalyst(data.type, data.cbor));
        }
      } catch (err) {
        if (keystoneSignResolve) {
          keystoneSignResolve({ error: (err == null ? void 0 : err.message) ?? JSON.stringify(err) });
        }
      }
      keystoneUR.value = void 0;
    }
    async function voteRegistration() {
      let keystoneSign = void 0;
      try {
        catalystKey.value = await generateCatalystKey(pinCode.value);
        if (isKeystone.value) {
          if (!accountData.value) {
            throw getDataSignErrorMsg(ErrorSignData.missingAccountData);
          }
          if (!walletData.value) {
            throw getDataSignErrorMsg(ErrorSignData.missingWalletData);
          }
          const ur = await createKeystoneCatalystRequest(accountData.value, walletData.value, catalystKey.value.privateKey);
          keystoneSign = await signWithKeystone(ur);
        }
      } catch (err) {
        $q.notify({
          type: "negative",
          message: (err == null ? void 0 : err.message) ?? JSON.stringify(err),
          position: "top-left",
          timeout: 8e3
        });
        return;
      }
      addSignalListener(onBuiltTxVoteReg, storeId, (res, error) => {
        removeSignalListener(onBuiltTxVoteReg, storeId);
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
      await dispatchSignal(doBuildTxVoteReg, catalystKey.value.privateKey, keystoneSign == null ? void 0 : keystoneSign.signature, keystoneSign == null ? void 0 : keystoneSign.nonce);
      removeSignalListener(onBuiltTxVoteReg, storeId);
    }
    function onPINsubmit(e) {
      hasSubmitError.value = false;
      pinCode.value.splice(0);
      pinCode.value.push(...e);
      gotoNext();
    }
    function votingPrerequisites() {
      var _a;
      votingPreReqError.value = "";
      if (networkId.value !== "mainnet" && networkId.value !== "preprod") {
        votingPreReqError.value = t("wallet.voting.catalyst.error.network");
        return;
      }
      if (!catalystData.value) {
        votingPreReqError.value = t("wallet.voting.catalyst.error.api");
        return;
      }
      const isRegistered = ((_a = rewardInfo.value) == null ? void 0 : _a.registered) ?? false;
      if (!isRegistered) {
        votingPreReqError.value = t("wallet.voting.catalyst.error.notregistered");
        return;
      }
    }
    watch(rewardInfo, () => {
      votingPrerequisites();
    });
    const _onTxSubmitted = async (tx) => {
      const ok = await setCatalystCIP15Key(catalystKey.value.encryptedKey);
      if (!ok) {
        votingError.value = t("wallet.voting.catalyst.error.save");
        console.error("Vote tx registration enc key:", catalystKey.value.encryptedKey);
        return;
      }
      currentStep.value = 0;
      await dispatchSignal(doOpenWalletSettings, "catalyst");
    };
    onMounted(() => addSignalListener(onTxSubmitted, storeId, _onTxSubmitted));
    onUnmounted(() => removeSignalListener(onTxSubmitted, storeId));
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(_sfc_main$i, {
          title: unref(t)("wallet.voting.catalyst.warning.registerForNextFund.label"),
          caption: unref(t)("wallet.voting.catalyst.warning.registerForNextFund.caption"),
          "show-modal": showWarningModal.value,
          onConfirm: _cache[0] || (_cache[0] = ($event) => confirmSnapshot())
        }, null, 8, ["title", "caption", "show-modal"]),
        createVNode(_sfc_main$f, {
          text: unref(t)("wallet.voting.catalyst.caption"),
          class: "col-span-12 cc-text-sz"
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12"
        }),
        createVNode(_sfc_main$m, {
          onBack: goBack,
          steps: optionsSteps,
          currentStep: currentStep.value,
          "show-stepper": votingPreReqError.value.length === 0,
          "small-c-s-s": "pr-9 sm:pr-20 md:pr-18 lg:pr-32"
        }, {
          step0: withCtx(() => {
            var _a, _b;
            return [
              votingPreReqError.value.length > 0 ? (openBlock(), createBlock(_sfc_main$g, {
                key: 0,
                text: votingPreReqError.value,
                icon: "mdi mdi-alert-octagon-outline",
                class: "col-span-12 mb-2",
                "text-c-s-s": "cc-text-normal flex justify-start items-center",
                css: "cc-rounded cc-banner-warning"
              }, null, 8, ["text"])) : createCommentVNode("", true),
              votingPreReqError.value.length > 0 ? (openBlock(), createBlock(GridSpace, {
                key: 1,
                hr: "",
                class: "col-span-12"
              })) : createCommentVNode("", true),
              createBaseVNode("div", _hoisted_1$2, [
                createBaseVNode("div", _hoisted_2$1, [
                  createVNode(_sfc_main$e, {
                    label: unref(t)("wallet.voting.catalyst.step.info.ideascale.header")
                  }, null, 8, ["label"]),
                  createVNode(_sfc_main$f, {
                    text: unref(t)("wallet.voting.catalyst.step.info.ideascale.caption"),
                    class: "cc-text-sz italic"
                  }, null, 8, ["text"]),
                  createVNode(_sfc_main$f, {
                    text: unref(t)("wallet.voting.catalyst.step.info.ideascale.text"),
                    class: "cc-text-sz mt-2"
                  }, null, 8, ["text"]),
                  createVNode(_sfc_main$j, {
                    url: unref(t)("wallet.voting.catalyst.step.info.ideascale.button.link"),
                    label: unref(t)("wallet.voting.catalyst.step.info.ideascale.button.label"),
                    "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
                    class: "mt-2 whitespace-nowrap"
                  }, null, 8, ["url", "label"])
                ]),
                createBaseVNode("div", _hoisted_3$1, [
                  createVNode(_sfc_main$e, {
                    label: unref(t)("wallet.voting.catalyst.step.info.newsletter.header")
                  }, null, 8, ["label"]),
                  createVNode(_sfc_main$f, {
                    text: unref(t)("wallet.voting.catalyst.step.info.newsletter.caption"),
                    class: "cc-text-sz italic"
                  }, null, 8, ["text"]),
                  createVNode(_sfc_main$f, {
                    text: unref(t)("wallet.voting.catalyst.step.info.newsletter.text"),
                    class: "cc-text-sz mt-2"
                  }, null, 8, ["text"]),
                  createVNode(_sfc_main$j, {
                    url: unref(t)("wallet.voting.catalyst.step.info.newsletter.button.link"),
                    label: unref(t)("wallet.voting.catalyst.step.info.newsletter.button.label"),
                    "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
                    class: "mt-2 whitespace-nowrap"
                  }, null, 8, ["url", "label"])
                ]),
                createBaseVNode("div", _hoisted_4$1, [
                  createVNode(_sfc_main$e, {
                    label: unref(t)("wallet.voting.catalyst.step.info.engage.header")
                  }, null, 8, ["label"]),
                  createVNode(_sfc_main$f, {
                    text: unref(t)("wallet.voting.catalyst.step.info.engage.caption"),
                    class: "cc-text-sz italic"
                  }, null, 8, ["text"]),
                  createVNode(_sfc_main$f, {
                    text: unref(t)("wallet.voting.catalyst.step.info.engage.text"),
                    class: "cc-text-sz mt-2"
                  }, null, 8, ["text"]),
                  createVNode(_sfc_main$j, {
                    url: unref(t)("wallet.voting.catalyst.step.info.engage.button1.link"),
                    label: unref(t)("wallet.voting.catalyst.step.info.engage.button1.label"),
                    "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
                    class: "mt-2 whitespace-nowrap"
                  }, null, 8, ["url", "label"]),
                  createVNode(_sfc_main$j, {
                    url: unref(t)("wallet.voting.catalyst.step.info.engage.button2.link"),
                    label: unref(t)("wallet.voting.catalyst.step.info.engage.button2.label"),
                    "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
                    class: "mt-2 whitespace-nowrap"
                  }, null, 8, ["url", "label"])
                ]),
                createBaseVNode("div", _hoisted_5$1, [
                  createVNode(_sfc_main$e, {
                    label: unref(t)("wallet.voting.catalyst.step.info.townhall.header")
                  }, null, 8, ["label"]),
                  createVNode(_sfc_main$f, {
                    text: unref(t)("wallet.voting.catalyst.step.info.townhall.caption"),
                    class: "cc-text-sz italic"
                  }, null, 8, ["text"]),
                  createVNode(_sfc_main$f, {
                    text: unref(t)("wallet.voting.catalyst.step.info.townhall.text"),
                    class: "cc-text-sz mt-2"
                  }, null, 8, ["text"]),
                  createVNode(_sfc_main$j, {
                    url: unref(t)("wallet.voting.catalyst.step.info.townhall.button.link"),
                    label: unref(t)("wallet.voting.catalyst.step.info.townhall.button.label"),
                    "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
                    class: "mt-2 whitespace-nowrap"
                  }, null, 8, ["url", "label"])
                ])
              ]),
              createVNode(GridSpace, {
                hr: "",
                class: "col-span-12 my-0.5 sm:my-2"
              }),
              catalystData.value ? (openBlock(), createElementBlock("div", _hoisted_6$1, [
                createVNode(_sfc_main$e, {
                  label: isNextFund.value ? (_a = catalystData.value) == null ? void 0 : _a.next.fund_name : (_b = catalystData.value) == null ? void 0 : _b.fund_name
                }, null, 8, ["label"]),
                createVNode(_sfc_main$f, {
                  text: unref(t)("wallet.voting.catalyst.step.info.fund.timeline.caption"),
                  class: "col-span-12 cc-text-sz"
                }, null, 8, ["text"]),
                timelineItems.length > 0 ? (openBlock(), createBlock(_sfc_main$3, {
                  key: 0,
                  steps: timelineItems,
                  currentStep: currentTimelineItem.value,
                  "stepper-c-s-s": "whitespace-nowrap ml-4 pb-3"
                }, null, 8, ["steps", "currentStep"])) : createCommentVNode("", true),
                !isNextFund.value ? (openBlock(), createElementBlock("div", _hoisted_7$1, [
                  createBaseVNode("div", {
                    onClick: _cache[1] || (_cache[1] = withModifiers(($event) => showChallenges.value = !showChallenges.value, ["stop"])),
                    class: "col-span-12 cursor-pointer"
                  }, [
                    createBaseVNode("i", {
                      class: normalizeClass(["mr-2", showChallenges.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
                    }, null, 2),
                    createBaseVNode("span", _hoisted_8$1, toDisplayString(unref(t)("wallet.voting.catalyst.step.info.fund.challenges." + (!showChallenges.value ? "show" : "hide"))), 1)
                  ]),
                  showChallenges.value && catalystData.value ? (openBlock(), createBlock(_sfc_main$a, {
                    key: 0,
                    "challenge-list": catalystData.value.challenges,
                    dense: ""
                  }, null, 8, ["challenge-list"])) : createCommentVNode("", true)
                ])) : createCommentVNode("", true),
                createVNode(GridSpace, {
                  hr: "",
                  class: normalizeClass(["col-span-12 pb-2", showChallenges.value ? "" : "pt-2 sm:pt-4"])
                }, null, 8, ["class"])
              ])) : createCommentVNode("", true),
              createVNode(_sfc_main$k, { active: isLoading.value }, null, 8, ["active"]),
              createVNode(_sfc_main$h, {
                label: unref(t)("wallet.voting.catalyst.step.app.button.next"),
                link: gotoNext,
                disabled: votingPreReqError.value.length > 0 && votingPreReqError.value !== unref(t)("wallet.voting.catalyst.error.api"),
                class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
              }, null, 8, ["label", "disabled"])
            ];
          }),
          step1: withCtx(() => [
            createVNode(_sfc_main$e, {
              label: unref(t)("wallet.voting.catalyst.step.app.header"),
              class: "col-span-12"
            }, null, 8, ["label"]),
            createVNode(_sfc_main$f, {
              text: unref(t)("wallet.voting.catalyst.step.app.caption"),
              class: "col-span-12 cc-text-sz"
            }, null, 8, ["text"]),
            createVNode(GridSpace, {
              hr: "",
              class: "col-span-12 my-0.5 sm:my-2"
            }),
            createBaseVNode("div", _hoisted_9$1, [
              !unref(isMobileApp)() || unref(isIosApp)() ? (openBlock(), createBlock(_sfc_main$7, {
                key: 0,
                "text-id": "wallet.voting.catalyst.step.app.apple",
                company: "apple"
              })) : createCommentVNode("", true),
              !unref(isMobileApp)() || !unref(isAndroidApp)() ? (openBlock(), createBlock(_sfc_main$7, {
                key: 1,
                "text-id": "wallet.voting.catalyst.step.app.android",
                company: "android"
              })) : createCommentVNode("", true)
            ]),
            createVNode(_sfc_main$g, {
              class: "col-span-12",
              css: " cc-text-semi-bold cc-area-highlight",
              dense: "",
              label: unref(t)("wallet.voting.catalyst.step.app.notice.label"),
              text: unref(t)("wallet.voting.catalyst.step.app.notice.text"),
              icon: unref(t)("wallet.voting.catalyst.step.app.notice.icon")
            }, null, 8, ["label", "text", "icon"]),
            createVNode(GridSpace, {
              hr: "",
              class: "col-span-12 py-2"
            }),
            createVNode(GridButtonSecondary, {
              label: unref(t)("common.label.back"),
              link: goBack,
              class: "col-start-0 col-span-6 lg:col-start-0 lg:col-span-3"
            }, null, 8, ["label"]),
            createVNode(_sfc_main$h, {
              label: unref(t)("wallet.voting.catalyst.step.app.button.next"),
              link: gotoNext,
              class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
            }, null, 8, ["label"])
          ]),
          step2: withCtx(() => [
            createVNode(_sfc_main$6, {
              "text-id": "wallet.voting.catalyst.step.pin",
              onSubmit: onPINsubmit
            }, {
              btnBack: withCtx(() => [
                createVNode(GridButtonSecondary, {
                  label: unref(t)("common.label.back"),
                  link: goBack,
                  class: "col-start-0 col-span-6 lg:col-start-0 lg:col-span-3"
                }, null, 8, ["label"])
              ]),
              _: 1
            })
          ]),
          step3: withCtx(() => [
            createVNode(_sfc_main$e, {
              label: unref(t)("wallet.voting.catalyst.step.tx.header"),
              class: "col-span-12"
            }, null, 8, ["label"]),
            createVNode(_sfc_main$f, {
              text: unref(t)("wallet.voting.catalyst.step.tx.caption"),
              class: "col-span-12 cc-text-sz"
            }, null, 8, ["text"]),
            createBaseVNode("div", _hoisted_10$1, [
              createVNode(IconWarning, { class: "w-7 flex-none mr-2" }),
              createVNode(_sfc_main$f, {
                text: unref(t)("wallet.voting.catalyst.step.tx.warning"),
                class: "cc-text-sz"
              }, null, 8, ["text"])
            ]),
            createVNode(GridSpace, {
              hr: "",
              class: "col-span-12 my-0.5 sm:my-2"
            }),
            votingError.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_11$1, [
              createVNode(IconError, { class: "w-7 flex-none mr-2" }),
              createVNode(_sfc_main$f, {
                text: votingError.value,
                class: "cc-text-sz"
              }, null, 8, ["text"])
            ])) : (openBlock(), createBlock(_sfc_main$h, {
              key: 1,
              label: unref(t)("wallet.voting.catalyst.step.app.button.register"),
              link: gotoNext,
              class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
            }, null, 8, ["label"])),
            isKeystone.value ? (openBlock(), createBlock(_sfc_main$l, {
              key: 2,
              label: unref(t)("wallet.keystone.catalyst"),
              open: !!keystoneUR.value,
              "keystone-u-r": keystoneUR.value,
              onClose: onKeystoneClose,
              onDecode: onKeystoneScan
            }, null, 8, ["label", "open", "keystone-u-r"])) : createCommentVNode("", true)
          ]),
          _: 1
        }, 8, ["steps", "currentStep", "show-stepper"])
      ], 64);
    };
  }
});
const getGovDRepInfo = (networkId2, accountId, cred, isScript) => {
  if (!accountId) {
    accountId = DEFAULT_ACCOUNT_ID;
  }
  return getRequestData()(
    networkId2,
    accountId,
    ApiRequestType.getGovDRepInfo,
    ErrorSync.getGovDRepInfo,
    {
      id: accountId,
      cred,
      isScript
    },
    async (data) => typeof data === "object" && data.bech32 ? data : null
  );
};
const _hoisted_1$1 = {
  key: 4,
  class: "col-span-12"
};
const _hoisted_2 = { class: "max-w-fit cc-rounded cc-shadow cc-bg-light-0 cc-p mt-1" };
const _hoisted_3 = { key: 0 };
const _hoisted_4 = {
  key: 1,
  class: "table-auto"
};
const _hoisted_5 = { class: "align-middle" };
const _hoisted_6 = ["colspan"];
const _hoisted_7 = {
  key: 0,
  class: "w-5 align-text-top"
};
const _hoisted_8 = { class: "flex flex-row flex-nowrap cc-gap" };
const _hoisted_9 = { class: "break-all font-mono pt-0.5" };
const _hoisted_10 = {
  key: 0,
  class: "align-middle opacity-50"
};
const _hoisted_11 = ["colspan"];
const _hoisted_12 = {
  key: 0,
  class: "w-5 align-text-top"
};
const _hoisted_13 = { class: "flex flex-row flex-nowrap cc-gap" };
const _hoisted_14 = { class: "break-all font-mono pt-0.5" };
const _hoisted_15 = {
  key: 1,
  class: "align-middle"
};
const _hoisted_16 = {
  colspan: "2",
  class: "pr-2 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_17 = {
  key: 2,
  class: "align-middle"
};
const _hoisted_18 = {
  colspan: "2",
  class: "pr-2 cc-text-semi-bold whitespace-nowrap"
};
const _hoisted_19 = { class: "flex flex-row flex-nowrap items-center" };
const _hoisted_20 = {
  key: 5,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_21 = { class: "col-span-12 cc-text-semi-bold" };
const _hoisted_22 = ["selected", "value"];
const _hoisted_23 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg" };
const _hoisted_24 = { class: "col-span-12 sm:col-span-6 2xl:col-span-4 cc-rounded cc-shadow cc-bg-light-0 cc-p" };
const _hoisted_25 = { class: "col-span-12 sm:col-span-6 2xl:col-span-4 cc-rounded cc-shadow cc-bg-light-0 cc-p" };
const _hoisted_26 = { class: "col-span-12 sm:col-span-6 2xl:col-span-4 cc-rounded cc-shadow cc-bg-light-0 cc-p" };
const _hoisted_27 = { class: "col-span-12 cc-rounded cc-shadow cc-bg-light-0 cc-p sm:mt-2" };
const _hoisted_28 = { class: "flex flex-row flex-nowrap gap-2 break-all font-mono mt-2 gap-2" };
const _hoisted_29 = {
  key: 8,
  class: "col-span-12"
};
const _hoisted_30 = { class: "cc-text-semi-bold" };
const _hoisted_31 = { class: "cc-text-semi-bold" };
const _hoisted_32 = {
  key: 9,
  class: "col-span-12 max-w-fit cc-banner-gray cc-p mt-2"
};
const _hoisted_33 = { class: "flex flex-row flex-nowrap cc-gap items-center" };
const _hoisted_34 = { class: "flex flex-col flex-nowrap cc-gap" };
const _hoisted_35 = { class: "flex flex-row flex-nowrap" };
const _hoisted_36 = { class: "cc-text-semi-bold" };
const _hoisted_37 = {
  key: 11,
  class: "col-span-12 grid grid-cols-12 cc-gap-lg"
};
const _hoisted_38 = { class: "col-span-12 cc-rounded cc-shadow cc-bg-light-0 cc-p flex flex-col gap-2" };
const _hoisted_39 = { class: "flex flex-col" };
const _hoisted_40 = { class: "w-full flex flex-row flex-nowrap mt-0.5 items-start pt-0.5 text-xs cc-text-semi-bold cc-gap" };
const _hoisted_41 = { class: "break-all text-center cc-addr" };
const _hoisted_42 = { class: "w-full flex flex-row flex-nowrap mt-0.5 items-start pt-0.5 text-xs cc-text-semi-bold cc-gap opacity-35" };
const _hoisted_43 = { class: "break-all text-center cc-addr" };
const _hoisted_44 = { class: "col-span-12 cc-rounded cc-shadow cc-bg-light-0 cc-p flex flex-col gap-2" };
const _hoisted_45 = { class: "flex flex-col" };
const _hoisted_46 = { class: "w-full flex flex-row flex-nowrap mt-0.5 items-start pt-0.5 text-xs cc-text-semi-bold cc-gap" };
const _hoisted_47 = { class: "break-all text-center cc-addr" };
const _hoisted_48 = { class: "w-full flex flex-row flex-nowrap mt-0.5 items-start pt-0.5 text-xs cc-text-semi-bold cc-gap opacity-35" };
const _hoisted_49 = { class: "break-all text-center cc-addr" };
const _hoisted_50 = { class: "col-span-12 cc-rounded cc-shadow cc-bg-light-0 cc-p flex flex-col gap-2" };
const _hoisted_51 = { class: "flex flex-col" };
const _hoisted_52 = { class: "w-full flex flex-row flex-nowrap mt-0.5 items-start pt-0.5 text-xs cc-text-semi-bold cc-gap" };
const _hoisted_53 = { class: "break-all text-center cc-addr" };
const _hoisted_54 = { class: "w-full flex flex-row flex-nowrap mt-0.5 items-start pt-0.5 text-xs cc-text-semi-bold cc-gap opacity-35" };
const _hoisted_55 = { class: "break-all text-center cc-addr" };
const _hoisted_56 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_57 = { class: "flex flex-col cc-text-sz" };
const _hoisted_58 = { class: "p-1" };
const _hoisted_59 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_60 = { class: "flex flex-col cc-text-sz" };
const _hoisted_61 = ["href"];
const _hoisted_62 = { class: "p-1" };
const _hoisted_63 = { class: "grid grid-cols-12 cc-gap p-2 w-full" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "Governance",
  setup(__props) {
    const storeId = "Governance" + getRandomId();
    const { t } = useTranslation();
    const $q = useQuasar();
    const { adaSymbol } = useAdaSymbol();
    const { getPercentDecimals } = useFormatter();
    const {
      appWallet,
      accountData,
      selectedAccountId,
      accountSettings
    } = useSelectedAccount();
    const showCreds = ref(false);
    const showAbstain = ref(false);
    const showNoConfidence = ref(false);
    const showAccountModal = ref(false);
    const showAnchorModal = ref(false);
    const customDRepID = ref("");
    const customDRepIDError = ref("");
    const drepAnchor = ref("");
    const drepAnchorError = ref("");
    const delegationDRepInfo = ref(null);
    const delegationOptions = [];
    delegationOptions.push(
      { id: "custom", label: t("wallet.voting.governance.delegation.new.options.custom") },
      { id: "own", label: t("wallet.voting.governance.delegation.new.options.own") }
    );
    if (networkId.value === "mainnet") {
      delegationOptions.push(
        { id: "eternl", label: t("wallet.voting.governance.delegation.new.options.eternl") }
      );
    }
    delegationOptions.push(
      { id: "abstain", label: t("wallet.voting.governance.delegation.new.options.abstain") },
      { id: "noconfidence", label: t("wallet.voting.governance.delegation.new.options.noconfidence") }
    );
    const selectedDelegationDRep = ref(delegationOptions[0].id);
    const rewardInfo = accountSettings.rewardInfo;
    const govToolURL = t("wallet.voting.governance.info.govtool." + networkId.value);
    const isTrezor = computed(() => {
      var _a;
      return ((_a = appWallet.value) == null ? void 0 : _a.isTrezor) ?? false;
    });
    const delegationDRep = computed(() => {
      var _a;
      if ((((_a = rewardInfo.value) == null ? void 0 : _a.govDelegationList) ?? []).length === 0) {
        return null;
      }
      return rewardInfo.value.govDelegationList.reduce((a, b) => {
        if (a.slot !== b.slot) {
          return a.slot > b.slot ? a : b;
        }
        return a.idx > b.idx ? a : b;
      });
    });
    const delegationDRepAddr = computed(
      () => delegationDRep.value && delegationDRep.value.drep.length === 56 ? getDRepAddressFromKeyHash(delegationDRep.value.drep, delegationDRep.value.isScript) : null
    );
    const delegationDRepAddrOld = computed(
      () => delegationDRep.value && delegationDRep.value.drep.length === 56 ? getDRepAddressFromKeyHashOld(delegationDRep.value.drep) : null
    );
    const delegationValue = computed(() => {
      if (!delegationDRep.value) {
        return t("wallet.voting.governance.delegation.current.undelegated");
      }
      switch (delegationDRep.value.drep) {
        case "drep_always_abstain":
          return t("wallet.voting.governance.delegation.new.options.abstain");
        case "drep_always_no_confidence":
          return t("wallet.voting.governance.delegation.new.options.noconfidence");
        default:
          return delegationDRepAddr.value ?? delegationDRep.value.drep;
      }
    });
    const delegationDRepStatus = computed(() => {
      if (!delegationDRepInfo.value) {
        return null;
      }
      const textId = "wallet.voting.governance.delegation.current.";
      if (delegationDRepInfo.value.registered && delegationDRepInfo.value.active) {
        return t(textId + "active");
      } else if (delegationDRepInfo.value.registered && !delegationDRepInfo.value.active) {
        return t(textId + "inactive");
      } else {
        return t(textId + "unregistered");
      }
    });
    const delegationDRepVotePower = computed(() => {
      var _a, _b;
      if (!delegationDRepInfo.value) {
        return null;
      }
      const drepStake = ((_a = delegationDRepInfo.value) == null ? void 0 : _a.drepStake) ?? "0";
      const totalStake = ((_b = delegationDRepInfo.value) == null ? void 0 : _b.totalStake) ?? "0";
      if (isZero(totalStake)) {
        return null;
      }
      return multiply(divide(drepStake, totalStake), 100);
    });
    const delegationDRepUtxo = computed(() => {
      if (!delegationDRepAddr.value) {
        return null;
      }
      return {
        input: { transaction_id: "", index: 0 },
        output: { address: delegationDRepAddr.value, amount: { coin: "0" } },
        pc: delegationDRep.value.drep,
        sc: ""
      };
    });
    const accDRepCred = computed(() => {
      var _a;
      if (!((_a = accountData.value) == null ? void 0 : _a.keys.drep) || accountData.value.keys.drep.length === 0) {
        return null;
      }
      return accountData.value.keys.drep[0].cred;
    });
    const accDRepAddr = computed(() => {
      if (!accDRepCred.value) {
        return "-";
      }
      return getDRepAddressFromKeyHash(accDRepCred.value, false);
    });
    const accDRepAddrOld = computed(() => {
      if (!accDRepCred.value) {
        return "-";
      }
      return getDRepAddressFromKeyHashOld(accDRepCred.value);
    });
    const ccColdAddr = computed(() => {
      var _a;
      if (!((_a = accountData.value) == null ? void 0 : _a.keys.cc_cold) || accountData.value.keys.cc_cold.length === 0) {
        return "-";
      }
      return getCCColdAddressFromKeyHash(accountData.value.keys.cc_cold[0].cred);
    });
    const ccColdAddrOld = computed(() => {
      var _a;
      if (!((_a = accountData.value) == null ? void 0 : _a.keys.cc_cold) || accountData.value.keys.cc_cold.length === 0) {
        return "-";
      }
      return getCCColdAddressFromKeyHashOld(accountData.value.keys.cc_cold[0].cred);
    });
    const ccHotAddr = computed(() => {
      var _a;
      if (!((_a = accountData.value) == null ? void 0 : _a.keys.cc_hot) || accountData.value.keys.cc_hot.length === 0) {
        return "-";
      }
      return getCCHotAddressFromKeyHash(accountData.value.keys.cc_hot[0].cred, false);
    });
    const ccHotAddrOld = computed(() => {
      var _a;
      if (!((_a = accountData.value) == null ? void 0 : _a.keys.cc_hot) || accountData.value.keys.cc_hot.length === 0) {
        return "-";
      }
      return getCCHotAddressFromKeyHashOld(accountData.value.keys.cc_hot[0].cred);
    });
    const isInvalidDrepDelegation = computed(() => {
      if (selectedDelegationDRep.value === "custom" && (customDRepID.value.length === 0 || customDRepIDError.value.length > 0)) {
        return true;
      } else if (selectedDelegationDRep.value === "own" && drepAnchorError.value.length > 0) {
        return true;
      }
      return false;
    });
    const onSelectDelegationDRep = (event) => {
      customDRepID.value = "";
      selectedDelegationDRep.value = event.target.options[event.target.options.selectedIndex].value;
    };
    const validateCustomDRepId = (value) => {
      customDRepIDError.value = "";
      if (value && (!value.startsWith("drep") || ![56, 58, 63].includes(value.length))) {
        customDRepIDError.value = "Invalid DRep ID";
      }
    };
    const validateDRepAnchor = (value) => {
      drepAnchorError.value = "";
      if (value) {
        let url;
        try {
          url = new URL(value);
          if (!url.origin || !url.origin.startsWith("http")) {
            throw new Error();
          }
        } catch (e) {
          drepAnchorError.value = "Invalid DRep Anchor URL";
        }
      }
    };
    const resetInput = () => {
      customDRepID.value = "";
      customDRepIDError.value = "";
      drepAnchor.value = "";
      drepAnchorError.value = "";
      showAccountModal.value = false;
      showAnchorModal.value = false;
    };
    const onDelegateToAccount = (info2) => {
      showAccountModal.value = false;
      const _appAccount = getIAppAccountById(info2.accountId, true);
      const _drepCred = (_appAccount == null ? void 0 : _appAccount.data.keys.drep) ? _appAccount.data.keys.drep[0].cred : null;
      if (!_drepCred) {
        $q.notify({
          type: "negative",
          message: t("wallet.voting.governance.delegation.new.error.accdrepmissing"),
          position: "top-left",
          timeout: 8e3
        });
        return;
      }
      if (selectedAccountId.value !== info2.accountId) {
        selectedDelegationDRep.value = "custom";
        customDRepID.value = getDRepAddressFromKeyHash(_drepCred, false);
        nextTick(() => voteDelegation());
      } else {
        showAnchorModal.value = true;
      }
    };
    const onVoteDelegation = (forced) => {
      if (forced) {
        selectedDelegationDRep.value = forced;
      }
      if (selectedDelegationDRep.value === "own") {
        showAccountModal.value = true;
      } else {
        voteDelegation();
      }
    };
    const voteDelegation = async () => {
      showAnchorModal.value = false;
      if (customDRepIDError.value.length > 0 || drepAnchorError.value.length > 0) {
        return;
      }
      let drepCred = "";
      let isScript = false;
      let errorMsg = "";
      let needDRepReg = false;
      let anchor = null;
      if (selectedDelegationDRep.value === "own") {
        if (!accDRepCred.value) {
          errorMsg = t("wallet.voting.governance.delegation.new.error.owndrepmissing");
        } else {
          drepCred = accDRepCred.value;
          anchor = drepAnchor.value.length === 0 ? null : drepAnchor.value;
        }
      } else if (selectedDelegationDRep.value === "eternl") {
        try {
          let _customDRepID = "drep13d6sxkyz6st9h65qqrzd8ukpywhr8swe9f6357qntgjqye0gttd";
          drepCred = decodeBech32(_customDRepID);
          if (customDRepID.value.length === 58) {
            isScript = drepCred.substring(1, 2) === "3";
            drepCred = drepCred.substring(2);
          } else if (customDRepID.value.length === 63) {
            isScript = true;
          }
          if (!drepCred) {
            errorMsg = t("wallet.voting.governance.delegation.new.error.invaliddrep");
          }
        } catch (err) {
          errorMsg = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
          if (errorMsg.length === 0) {
            errorMsg = t("wallet.voting.governance.delegation.new.error.unknown");
          }
        }
      } else if (selectedDelegationDRep.value === "custom") {
        try {
          let _customDRepID = customDRepID.value;
          drepCred = decodeBech32(_customDRepID);
          if (customDRepID.value.length === 58) {
            isScript = drepCred.substring(1, 2) === "3";
            drepCred = drepCred.substring(2);
          } else if (customDRepID.value.length === 63) {
            isScript = true;
          }
          if (!drepCred) {
            errorMsg = t("wallet.voting.governance.delegation.new.error.invaliddrep");
          }
        } catch (err) {
          errorMsg = (err == null ? void 0 : err.message) ?? JSON.stringify(err);
          if (errorMsg.length === 0) {
            errorMsg = t("wallet.voting.governance.delegation.new.error.unknown");
          }
        }
      }
      if (errorMsg.length === 0 && drepCred.length > 0) {
        let drepInfo = null;
        try {
          drepInfo = await getGovDRepInfo(networkId.value, selectedAccountId.value, drepCred, isScript);
        } catch (e) {
        }
        if (!drepInfo || !drepInfo.registered) {
          if (selectedDelegationDRep.value === "own") {
            needDRepReg = true;
          } else {
            errorMsg = t("wallet.voting.governance.delegation.new.error.notregistered");
          }
        }
      }
      if (errorMsg.length > 0) {
        $q.notify({
          type: "negative",
          message: errorMsg,
          position: "top-left",
          timeout: 8e3
        });
        return;
      }
      addSignalListener(onBuiltTxVoteDelegation, storeId, (res, error) => {
        removeSignalListener(onBuiltTxVoteDelegation, storeId);
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
          resetInput();
        } else if (error) {
          $q.notify({
            type: "negative",
            message: error,
            position: "top-left",
            timeout: 8e3
          });
          resetInput();
        }
      });
      if (selectedDelegationDRep.value === "abstain") {
        drepCred = "abstain";
      } else if (selectedDelegationDRep.value === "noconfidence") {
        drepCred = "noconfidence";
      }
      await dispatchSignal(doBuildTxVoteDelegation, drepCred, isScript, needDRepReg, anchor);
      resetInput();
      removeSignalListener(onBuiltTxVoteReg, storeId);
    };
    const fetchCurrDRepInfo = async () => {
      if (!delegationDRep.value) {
        return;
      }
      try {
        delegationDRepInfo.value = await getGovDRepInfo(networkId.value, selectedAccountId.value, delegationDRep.value.drep, delegationDRep.value.isScript);
      } catch (e) {
        console.error("getGovDRepInfo:", e);
      }
    };
    watch(delegationDRep, () => fetchCurrDRepInfo());
    onMounted(() => {
      fetchCurrDRepInfo();
    });
    onUnmounted(() => removeSignalListener(onEpochParamsUpdated, storeId));
    return (_ctx, _cache) => {
      var _a, _b, _c;
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(_sfc_main$f, {
          text: unref(t)("wallet.voting.governance.caption"),
          class: "col-span-12 cc-text-sz"
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12 my-0.5 sm:mb-2"
        }),
        !unref(epochParams) || !unref(epochParams).isAtLeastConwayEra ? (openBlock(), createBlock(_sfc_main$g, {
          key: 0,
          dense: "",
          class: "col-span-12",
          css: "cc-rounded cc-banner-warning",
          text: unref(t)("wallet.voting.governance.era"),
          icon: unref(t)("wallet.summary.stakeinfo.gov.icon.warning")
        }, null, 8, ["text", "icon"])) : unref(epochParams).isAtLeastConwayEra2 && (((_a = unref(rewardInfo)) == null ? void 0 : _a.govDelegationList.length) ?? 0) === 0 ? (openBlock(), createBlock(_sfc_main$g, {
          key: 1,
          html: "",
          class: "col-span-12",
          css: "cc-rounded cc-banner-warning",
          text: unref(t)("wallet.summary.stakeinfo.gov.nodelegation.warn"),
          icon: unref(t)("wallet.summary.stakeinfo.gov.icon.warning")
        }, null, 8, ["text", "icon"])) : unref(epochParams).isAtLeastConwayEra && (((_b = unref(rewardInfo)) == null ? void 0 : _b.govDelegationList.length) ?? 0) === 0 ? (openBlock(), createBlock(_sfc_main$g, {
          key: 2,
          html: "",
          class: "col-span-12",
          css: "cc-rounded cc-banner-blue",
          text: unref(t)("wallet.summary.stakeinfo.gov.nodelegation.info"),
          icon: unref(t)("wallet.summary.stakeinfo.gov.icon.info")
        }, null, 8, ["text", "icon"])) : !((_c = unref(rewardInfo)) == null ? void 0 : _c.hasActiveDRep) ? (openBlock(), createBlock(_sfc_main$g, {
          key: 3,
          html: "",
          class: "col-span-12",
          css: "cc-rounded cc-banner-warning",
          text: unref(t)("wallet.summary.stakeinfo.gov.inactive"),
          icon: unref(t)("wallet.summary.stakeinfo.gov.icon.warning")
        }, null, 8, ["text", "icon"])) : createCommentVNode("", true),
        unref(epochParams).isAtLeastConwayEra ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
          createVNode(_sfc_main$e, {
            label: unref(t)("wallet.voting.governance.delegation.current.label")
          }, null, 8, ["label"]),
          createBaseVNode("div", _hoisted_2, [
            !delegationDRep.value ? (openBlock(), createElementBlock("div", _hoisted_3, toDisplayString(delegationValue.value), 1)) : (openBlock(), createElementBlock("table", _hoisted_4, [
              createBaseVNode("tbody", null, [
                createBaseVNode("tr", _hoisted_5, [
                  createBaseVNode("td", {
                    colspan: delegationDRepAddr.value ? 1 : 2,
                    class: "pr-2 cc-text-semi-bold whitespace-nowrap"
                  }, toDisplayString(unref(t)(`wallet.voting.governance.delegation.current.${delegationDRepAddr.value ? "drep" : "vote"}`)) + ":", 9, _hoisted_6),
                  delegationDRepAddr.value ? (openBlock(), createElementBlock("td", _hoisted_7, [
                    createVNode(_sfc_main$n, {
                      "label-hover": unref(t)("wallet.voting.governance.copy.address.hover"),
                      "notification-text": unref(t)("wallet.voting.governance.copy.address.notify"),
                      "copy-text": delegationDRepAddr.value,
                      class: "ml-1 inline-flex items-center justify-center"
                    }, null, 8, ["label-hover", "notification-text", "copy-text"])
                  ])) : createCommentVNode("", true),
                  createBaseVNode("td", _hoisted_8, [
                    createBaseVNode("div", _hoisted_9, toDisplayString(delegationValue.value), 1),
                    delegationDRepUtxo.value ? (openBlock(), createBlock(_sfc_main$o, {
                      key: 0,
                      utxo: delegationDRepUtxo.value,
                      "account-id": unref(selectedAccountId),
                      "navigation-page": "Summary",
                      "cred-type": "drep"
                    }, null, 8, ["utxo", "account-id"])) : createCommentVNode("", true)
                  ])
                ]),
                delegationDRepAddrOld.value ? (openBlock(), createElementBlock("tr", _hoisted_10, [
                  createBaseVNode("td", {
                    colspan: delegationDRepAddrOld.value ? 1 : 2,
                    class: "pr-2 cc-text-semi-bold whitespace-nowrap"
                  }, toDisplayString(unref(t)(`wallet.voting.governance.delegation.current.${delegationDRepAddrOld.value ? "drepOld" : "vote"}`)) + ":", 9, _hoisted_11),
                  delegationDRepAddrOld.value ? (openBlock(), createElementBlock("td", _hoisted_12, [
                    createVNode(_sfc_main$n, {
                      "label-hover": unref(t)("wallet.voting.governance.copy.address.hover"),
                      "notification-text": unref(t)("wallet.voting.governance.copy.address.notify"),
                      "copy-text": delegationDRepAddrOld.value,
                      class: "ml-1 flex inline-flex items-center justify-center"
                    }, null, 8, ["label-hover", "notification-text", "copy-text"])
                  ])) : createCommentVNode("", true),
                  createBaseVNode("td", _hoisted_13, [
                    createBaseVNode("div", _hoisted_14, toDisplayString(delegationDRepAddrOld.value) + " (legacy)", 1),
                    delegationDRepUtxo.value ? (openBlock(), createBlock(_sfc_main$o, {
                      key: 0,
                      utxo: delegationDRepUtxo.value,
                      "account-id": unref(selectedAccountId),
                      "navigation-page": "Summary",
                      "cred-type": "drep"
                    }, null, 8, ["utxo", "account-id"])) : createCommentVNode("", true)
                  ])
                ])) : createCommentVNode("", true),
                delegationDRepStatus.value && delegationDRepAddr.value ? (openBlock(), createElementBlock("tr", _hoisted_15, [
                  createBaseVNode("td", _hoisted_16, toDisplayString(unref(t)("wallet.voting.governance.delegation.current.status")) + ":", 1),
                  createBaseVNode("td", null, toDisplayString(delegationDRepStatus.value), 1)
                ])) : createCommentVNode("", true),
                delegationDRepVotePower.value ? (openBlock(), createElementBlock("tr", _hoisted_17, [
                  createBaseVNode("td", _hoisted_18, toDisplayString(unref(t)("wallet.voting.governance.delegation.current.votepower")) + ":", 1),
                  createBaseVNode("td", _hoisted_19, [
                    createVNode(_sfc_main$d, {
                      amount: delegationDRepVotePower.value,
                      percent: true,
                      "whole-c-s-s": "",
                      "fraction-c-s-s": "",
                      decimals: unref(getPercentDecimals)(delegationDRepVotePower.value, false)
                    }, null, 8, ["amount", "decimals"]),
                    _cache[9] || (_cache[9] = createBaseVNode("div", { class: "ml-1 mr-0.5" }, "(", -1)),
                    createVNode(_sfc_main$d, {
                      "show-fraction": false,
                      amount: delegationDRepInfo.value.drepStake,
                      "balance-always-visible": ""
                    }, null, 8, ["amount"]),
                    _cache[10] || (_cache[10] = createBaseVNode("div", { class: "ml-0.5" }, ")", -1))
                  ])
                ])) : createCommentVNode("", true)
              ])
            ]))
          ])
        ])) : createCommentVNode("", true),
        unref(epochParams).isAtLeastConwayEra ? (openBlock(), createElementBlock("div", _hoisted_20, [
          createVNode(GridSpace, {
            hr: "",
            class: "col-span-12 my-0.5 sm:mt-2"
          }),
          createBaseVNode("span", _hoisted_21, toDisplayString(unref(t)("wallet.voting.governance.delegation.new.label")), 1),
          createBaseVNode("select", {
            class: "col-span-12 sm:col-span-4 xl:col-span-4 cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[0] || (_cache[0] = ($event) => onSelectDelegationDRep($event))
          }, [
            (openBlock(), createElementBlock(Fragment, null, renderList(delegationOptions, (option) => {
              return createBaseVNode("option", {
                key: option.id,
                selected: option.id === selectedDelegationDRep.value,
                value: option.id
              }, toDisplayString(option.label), 9, _hoisted_22);
            }), 64))
          ], 32),
          createVNode(_sfc_main$h, {
            label: unref(t)("wallet.voting.governance.delegation.new.button.delegate"),
            link: onVoteDelegation,
            disabled: isInvalidDrepDelegation.value,
            class: "col-span-6 sm:col-span-4 xl:col-span-3"
          }, null, 8, ["label", "disabled"]),
          selectedDelegationDRep.value === "custom" ? (openBlock(), createBlock(GridInput, {
            key: 0,
            "input-text": customDRepID.value,
            "onUpdate:inputText": [
              _cache[1] || (_cache[1] = ($event) => customDRepID.value = $event),
              validateCustomDRepId
            ],
            "input-error": customDRepIDError.value,
            "onUpdate:inputError": _cache[2] || (_cache[2] = ($event) => customDRepIDError.value = $event),
            onReset: resetInput,
            class: "col-span-12 mt-2",
            showReset: true,
            "input-id": "inputCustomDRepID",
            "input-hint": "drep1...",
            "input-type": "text"
          }, {
            "icon-prepend": withCtx(() => [
              createVNode(IconPencil, { class: "h-5 w-5" })
            ]),
            _: 1
          }, 8, ["input-text", "input-error"])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12 my-0.5 sm:my-2"
        }),
        createVNode(_sfc_main$e, { label: "Choose a DRep" }),
        createBaseVNode("div", _hoisted_23, [
          createBaseVNode("div", _hoisted_24, [
            createVNode(_sfc_main$e, { label: "Voltaire GovTool" }),
            createVNode(_sfc_main$f, {
              text: "The Voltaire Govtool is a community tool that supports the key steps of Cardano's Governance process described in CIP1694. Govtool is part of the core governance tools currently managed by the Intersect Governance tools WG.",
              class: "cc-text-sz mt-2"
            }),
            createVNode(_sfc_main$j, {
              url: "https://gov.tools",
              label: "gov.tools",
              "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
              class: "mt-2 whitespace-nowrap"
            })
          ]),
          createBaseVNode("div", _hoisted_25, [
            createVNode(_sfc_main$e, { label: "1694.io" }),
            createVNode(_sfc_main$f, {
              text: "1694.io by Lido Nation is a community platform to help Cardanians learn about and participate in Cardano governance. The platform is designed to embody the principles of transparency, inclusivity, and innovation that define the Cardano ecosystem.",
              class: "cc-text-sz mt-2"
            }),
            createVNode(_sfc_main$j, {
              url: "https://www.1694.io/",
              label: "1694.io",
              "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
              class: "mt-2 whitespace-nowrap"
            })
          ]),
          createBaseVNode("div", _hoisted_26, [
            createVNode(_sfc_main$e, { label: "Tempo" }),
            createVNode(_sfc_main$f, {
              text: "A governance tool designed to streamline and enhance Cardano’s decision-making processes.",
              class: "cc-text-sz mt-2"
            }),
            createVNode(_sfc_main$j, {
              url: "https://tempo.vote/",
              label: "tempo.vote",
              "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
              class: "mt-2 whitespace-nowrap"
            })
          ])
        ]),
        createBaseVNode("div", _hoisted_27, [
          createVNode(_sfc_main$e, { label: "Eternl DRep Committee" }),
          createVNode(_sfc_main$f, {
            text: "Our motivation to register as a DRep stems from a deep commitment to the Cardano ecosystem and a desire to play an active role in its evolution, ensuring its growth aligns with the principles of decentralization, security, and community empowerment.",
            class: "cc-text-sz mt-2"
          }),
          createVNode(_sfc_main$f, { text: "Please consider delegating your voting power to us." }),
          createBaseVNode("div", _hoisted_28, [
            _cache[11] || (_cache[11] = createBaseVNode("span", null, toDisplayString("drep13d6sxkyz6st9h65qqrzd8ukpywhr8swe9f6357qntgjqye0gttd"), -1)),
            createVNode(_sfc_main$n, { "copy-text": "drep13d6sxkyz6st9h65qqrzd8ukpywhr8swe9f6357qntgjqye0gttd" })
          ]),
          createVNode(_sfc_main$h, {
            label: unref(t)("wallet.voting.governance.delegation.new.button.delegate"),
            link: () => {
              onVoteDelegation("eternl");
            },
            class: "h-8 px-4 mt-3"
          }, null, 8, ["label", "link"])
        ]),
        unref(epochParams).isAtLeastConwayEra ? (openBlock(), createBlock(GridSpace, {
          key: 6,
          hr: "",
          class: "col-span-12 my-0.5 sm:my-2"
        })) : createCommentVNode("", true),
        unref(epochParams).isAtLeastConwayEra ? (openBlock(), createBlock(_sfc_main$g, {
          key: 7,
          nopadding: "",
          class: "col-span-12",
          css: "",
          text: unref(t)("wallet.voting.governance.info.text")
        }, null, 8, ["text"])) : createCommentVNode("", true),
        unref(epochParams).isAtLeastConwayEra ? (openBlock(), createElementBlock("div", _hoisted_29, [
          createBaseVNode("div", {
            onClick: _cache[3] || (_cache[3] = withModifiers(($event) => showAbstain.value = !showAbstain.value, ["stop"])),
            class: "cursor-pointer mb-1"
          }, [
            createBaseVNode("i", {
              class: normalizeClass(["mr-2", showAbstain.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2),
            createBaseVNode("span", _hoisted_30, toDisplayString(unref(t)("wallet.voting.governance.info.abstain.label")), 1)
          ]),
          showAbstain.value ? (openBlock(), createBlock(_sfc_main$g, {
            key: 0,
            nopadding: "",
            css: "mb-2",
            text: unref(t)("wallet.voting.governance.info.abstain.text")
          }, null, 8, ["text"])) : createCommentVNode("", true),
          createBaseVNode("div", {
            onClick: _cache[4] || (_cache[4] = withModifiers(($event) => showNoConfidence.value = !showNoConfidence.value, ["stop"])),
            class: "cursor-pointer my-1"
          }, [
            createBaseVNode("i", {
              class: normalizeClass(["mr-2", showNoConfidence.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2),
            createBaseVNode("span", _hoisted_31, toDisplayString(unref(t)("wallet.voting.governance.info.noconfidence.label")), 1)
          ]),
          showNoConfidence.value ? (openBlock(), createBlock(_sfc_main$g, {
            key: 1,
            nopadding: "",
            css: "",
            text: unref(t)("wallet.voting.governance.info.noconfidence.text")
          }, null, 8, ["text"])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        unref(govToolURL).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_32, [
          createBaseVNode("div", _hoisted_33, [
            _cache[12] || (_cache[12] = createBaseVNode("i", { class: "mdi mdi-information-outline text-xl sm:text-2xl" }, null, -1)),
            createBaseVNode("div", _hoisted_34, [
              createBaseVNode("div", _hoisted_35, [
                createBaseVNode("span", null, toDisplayString(unref(t)("wallet.voting.governance.info.govtool.info")), 1),
                createVNode(_sfc_main$j, {
                  url: unref(govToolURL),
                  label: unref(t)("wallet.voting.governance.info.govtool.label"),
                  "label-c-s-s": "cc-text-semi-bold cc-text-highlight-hover",
                  class: "ml-1"
                }, null, 8, ["url", "label"])
              ]),
              createBaseVNode("div", null, toDisplayString(unref(t)("wallet.voting.governance.info.note")), 1)
            ])
          ])
        ])) : createCommentVNode("", true),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12 my-0.5 sm:my-2"
        }),
        !isTrezor.value ? (openBlock(), createElementBlock("div", {
          key: 10,
          onClick: _cache[5] || (_cache[5] = withModifiers(($event) => showCreds.value = !showCreds.value, ["stop"])),
          class: "col-span-12 cursor-pointer mb-2"
        }, [
          createBaseVNode("i", {
            class: normalizeClass(["mr-2", showCreds.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
          }, null, 2),
          createBaseVNode("span", _hoisted_36, toDisplayString(unref(t)("wallet.voting.governance.key." + (!showCreds.value ? "show" : "hide"))), 1)
        ])) : createCommentVNode("", true),
        showCreds.value ? (openBlock(), createElementBlock("div", _hoisted_37, [
          createVNode(_sfc_main$g, {
            nopadding: "",
            class: "col-span-12",
            css: "",
            text: unref(t)("wallet.voting.governance.key.info")
          }, null, 8, ["text"]),
          createBaseVNode("div", _hoisted_38, [
            createVNode(_sfc_main$e, {
              label: unref(t)("wallet.voting.governance.key.drep.header")
            }, null, 8, ["label"]),
            createVNode(_sfc_main$f, {
              text: unref(t)("wallet.voting.governance.key.drep.caption"),
              class: "cc-text-sz italic"
            }, null, 8, ["text"]),
            createBaseVNode("div", _hoisted_39, [
              createBaseVNode("div", _hoisted_40, [
                _cache[13] || (_cache[13] = createBaseVNode("div", { class: "cc-addr" }, "(CIP129)", -1)),
                createVNode(_sfc_main$n, {
                  "label-hover": unref(t)("wallet.voting.governance.copy.address.hover"),
                  "notification-text": unref(t)("wallet.voting.governance.copy.address.notify"),
                  "copy-text": accDRepAddr.value
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createBaseVNode("div", _hoisted_41, toDisplayString(accDRepAddr.value), 1)
              ]),
              createBaseVNode("div", _hoisted_42, [
                _cache[14] || (_cache[14] = createBaseVNode("div", { class: "cc-addr" }, "(CIP105)", -1)),
                createVNode(_sfc_main$n, {
                  "label-hover": unref(t)("wallet.voting.governance.copy.address.hover"),
                  "notification-text": unref(t)("wallet.voting.governance.copy.address.notify"),
                  "copy-text": accDRepAddrOld.value
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createBaseVNode("div", _hoisted_43, toDisplayString(accDRepAddrOld.value) + " (legacy)", 1)
              ])
            ])
          ]),
          createBaseVNode("div", _hoisted_44, [
            createVNode(_sfc_main$e, {
              label: unref(t)("wallet.voting.governance.key.cccold.header")
            }, null, 8, ["label"]),
            createVNode(_sfc_main$f, {
              text: unref(t)("wallet.voting.governance.key.cccold.caption"),
              class: "cc-text-sz italic"
            }, null, 8, ["text"]),
            createBaseVNode("div", _hoisted_45, [
              createBaseVNode("div", _hoisted_46, [
                _cache[15] || (_cache[15] = createBaseVNode("div", { class: "cc-addr" }, "(CIP129)", -1)),
                createVNode(_sfc_main$n, {
                  "label-hover": unref(t)("wallet.voting.governance.copy.address.hover"),
                  "notification-text": unref(t)("wallet.voting.governance.copy.address.notify"),
                  "copy-text": ccColdAddr.value
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createBaseVNode("div", _hoisted_47, toDisplayString(ccColdAddr.value), 1)
              ]),
              createBaseVNode("div", _hoisted_48, [
                _cache[16] || (_cache[16] = createBaseVNode("div", { class: "cc-addr" }, "(CIP105)", -1)),
                createVNode(_sfc_main$n, {
                  "label-hover": unref(t)("wallet.voting.governance.copy.address.hover"),
                  "notification-text": unref(t)("wallet.voting.governance.copy.address.notify"),
                  "copy-text": ccColdAddrOld.value
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createBaseVNode("div", _hoisted_49, toDisplayString(ccColdAddrOld.value) + " (legacy)", 1)
              ])
            ])
          ]),
          createBaseVNode("div", _hoisted_50, [
            createVNode(_sfc_main$e, {
              label: unref(t)("wallet.voting.governance.key.cchot.header")
            }, null, 8, ["label"]),
            createVNode(_sfc_main$f, {
              text: unref(t)("wallet.voting.governance.key.cchot.caption"),
              class: "cc-text-sz italic"
            }, null, 8, ["text"]),
            createBaseVNode("div", _hoisted_51, [
              createBaseVNode("div", _hoisted_52, [
                _cache[17] || (_cache[17] = createBaseVNode("div", { class: "cc-addr" }, "(CIP129)", -1)),
                createVNode(_sfc_main$n, {
                  "label-hover": unref(t)("wallet.voting.governance.copy.address.hover"),
                  "notification-text": unref(t)("wallet.voting.governance.copy.address.notify"),
                  "copy-text": ccHotAddr.value
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createBaseVNode("div", _hoisted_53, toDisplayString(ccHotAddr.value), 1)
              ]),
              createBaseVNode("div", _hoisted_54, [
                _cache[18] || (_cache[18] = createBaseVNode("div", { class: "cc-addr" }, "(CIP105)", -1)),
                createVNode(_sfc_main$n, {
                  "label-hover": unref(t)("wallet.voting.governance.copy.address.hover"),
                  "notification-text": unref(t)("wallet.voting.governance.copy.address.notify"),
                  "copy-text": ccHotAddrOld.value
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createBaseVNode("div", _hoisted_55, toDisplayString(ccHotAddrOld.value) + " (legacy)", 1)
              ])
            ])
          ])
        ])) : createCommentVNode("", true),
        showAccountModal.value ? (openBlock(), createBlock(Modal, {
          key: 12,
          onClose: resetInput,
          "full-width-on-mobile": ""
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_56, [
              createBaseVNode("div", _hoisted_57, [
                createVNode(_sfc_main$e, {
                  label: unref(t)("wallet.voting.governance.delegation.new.accModal.label")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$f, {
                  text: unref(t)("wallet.voting.governance.delegation.new.accModal.caption")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_58, [
              createVNode(_sfc_main$p, {
                "text-id": "wallet.voting.governance.delegation.new.accModal",
                onOnSendToAccount: onDelegateToAccount
              })
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        showAnchorModal.value ? (openBlock(), createBlock(Modal, {
          key: 13,
          onClose: resetInput,
          narrow: "",
          "full-width-on-mobile": ""
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_59, [
              createBaseVNode("div", _hoisted_60, [
                createVNode(_sfc_main$e, {
                  label: unref(t)("wallet.voting.governance.delegation.new.anchorModal.label")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$f, {
                  text: unref(t)("wallet.voting.governance.delegation.new.anchorModal.caption")
                }, null, 8, ["text"]),
                createBaseVNode("a", {
                  href: unref(t)("wallet.voting.governance.delegation.new.anchorModal.link"),
                  target: "_blank"
                }, _cache[19] || (_cache[19] = [
                  createBaseVNode("u", null, "Guide to store metadata.", -1)
                ]), 8, _hoisted_61)
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_62, [
              createVNode(GridInput, {
                "input-text": drepAnchor.value,
                "onUpdate:inputText": [
                  _cache[6] || (_cache[6] = ($event) => drepAnchor.value = $event),
                  validateDRepAnchor
                ],
                "input-error": drepAnchorError.value,
                "onUpdate:inputError": _cache[7] || (_cache[7] = ($event) => drepAnchorError.value = $event),
                onEnter: _cache[8] || (_cache[8] = ($event) => voteDelegation()),
                onReset: resetInput,
                class: "col-span-12 my-2",
                showReset: true,
                "input-hint": unref(t)("wallet.voting.governance.delegation.new.anchorModal.hint"),
                "input-id": "inputDRepAnchor",
                "input-type": "url"
              }, {
                "icon-prepend": withCtx(() => [
                  createVNode(IconPencil, { class: "h-5 w-5" })
                ]),
                _: 1
              }, 8, ["input-text", "input-error", "input-hint"])
            ])
          ]),
          footer: withCtx(() => [
            createBaseVNode("div", _hoisted_63, [
              createVNode(GridButtonSecondary, {
                label: unref(t)("common.label.cancel"),
                link: resetInput,
                class: "col-span-6"
              }, null, 8, ["label"]),
              createVNode(_sfc_main$h, {
                label: unref(t)("common.label.next"),
                link: voteDelegation,
                disabled: drepAnchorError.value.length > 0,
                class: "col-span-6"
              }, null, 8, ["label", "disabled"])
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1 = { class: "cc-page-wallet cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Voting",
  setup(__props) {
    onErrorCaptured((e) => {
      console.error("Voting: onErrorCaptured", e);
      return true;
    });
    const storeId = "Voting" + getRandomId();
    const { t } = useTranslation();
    const optionsTabs = reactive([
      { id: "catalyst", label: t("wallet.voting.tab.catalyst"), index: 0 },
      { id: "governance", label: t("wallet.voting.tab.governance"), index: 1 }
    ]);
    const catalystIsEnabled = ref(isCatalystEnabled(networkId.value));
    const governanceIsEnabled = ref(isGovernanceEnabled(networkId.value));
    const _onNetworkFeaturesUpdated = () => {
      catalystIsEnabled.value = isCatalystEnabled(networkId.value);
      governanceIsEnabled.value = isGovernanceEnabled(networkId.value);
    };
    onMounted(() => addSignalListener(onNetworkFeaturesUpdated, storeId, _onNetworkFeaturesUpdated));
    onUnmounted(() => removeSignalListener(onNetworkFeaturesUpdated, storeId));
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        catalystIsEnabled.value && governanceIsEnabled.value ? (openBlock(), createBlock(_sfc_main$q, {
          key: 0,
          tabs: optionsTabs
        }, {
          tab0: withCtx(() => [
            createVNode(_sfc_main$2)
          ]),
          tab1: withCtx(() => [
            createVNode(_sfc_main$1)
          ]),
          _: 1
        }, 8, ["tabs"])) : catalystIsEnabled.value ? (openBlock(), createBlock(_sfc_main$2, { key: 1 })) : governanceIsEnabled.value ? (openBlock(), createBlock(_sfc_main$1, { key: 2 })) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as default
};
