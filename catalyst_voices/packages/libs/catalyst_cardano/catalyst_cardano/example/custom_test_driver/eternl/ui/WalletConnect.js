import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$f } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$e } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, be as useWalletAccount, S as reactive, w as watchEffect, aG as onUnmounted, o as openBlock, c as createElementBlock, q as createVNode, u as unref, e as createBaseVNode, H as Fragment, I as renderList, j as createCommentVNode, a as createBlock, df as useUiSelectedAccount, d9 as getWalletNameList, dl as selectedWalletId, t as toDisplayString, z as ref, i as createTextVNode, n as normalizeClass, B as useFormatter, a5 as toRefs, f as computed, K as networkId, h as withCtx, a7 as useQuasar, C as onMounted, D as watch, dh as walletsExists, bI as onBeforeMount, b as withModifiers, V as nextTick, dm as getRewardAddressFromCred, aH as QPagination_default, ct as onErrorCaptured } from "./index.js";
import { u as useDappAccount } from "./useDappAccount.js";
import { u as useWalletConnect, W as WalletConnectManager, s as saveWalletConnect, b as buildWalletConnectParams, w as walletConnectDBList, a as updateWalletConnectList } from "./WalletConnectManager.js";
import { _ as _sfc_main$7, a as _sfc_main$8 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { G as GridInput } from "./GridInput.js";
import { I as IconPencil } from "./IconPencil.js";
import { _ as _sfc_main$c } from "./ScanQrCode2.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$9 } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$a } from "./DAppsAccountItem.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$b } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { I as IconWarning } from "./IconWarning.js";
import { _ as _sfc_main$d } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./_plugin-vue_export-helper.js";
import "./useTabId.js";
import "./NetworkId.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./IconError.js";
import "./QrcodeStream.js";
import "./scanner.js";
import "./AccountItemBalance.vue_vue_type_script_setup_true_lang.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1$6 = { class: "cc-grid cc-text-sz" };
const _hoisted_2$6 = {
  key: 0,
  class: "cc-grid"
};
const _hoisted_3$6 = { class: "col-span-12 grid grid-cols-12 cc-gap mb-2" };
const _hoisted_4$5 = ["selected", "value"];
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "DAppsWalletConnectAccountList",
  props: {
    dappId: { type: String, required: false }
  },
  setup(__props, { expose: __expose }) {
    const { it } = useTranslation();
    const {
      dappWalletId,
      dappAccountId
    } = useDappAccount();
    const {
      uiSelectedAccountId,
      uiSelectedWalletId,
      setUiSelectedAccountId,
      setUiSelectedWalletId,
      resetSelection
    } = useUiSelectedAccount();
    const {
      appWallet,
      appAccount,
      walletData,
      accountList
    } = useWalletAccount(uiSelectedWalletId, uiSelectedAccountId);
    const walletNameList = reactive([]);
    const handleWalletList = () => {
      walletNameList.splice(0, walletNameList.length, ...getWalletNameList());
      walletNameList.sort((a, b) => a.name.localeCompare(b.name, "en-US"));
    };
    handleWalletList();
    watchEffect(() => {
      var _a;
      if (dappAccountId.value && !uiSelectedWalletId.value) {
        setUiSelectedWalletId(dappWalletId.value, false);
        setUiSelectedAccountId(dappAccountId.value, false);
      } else if (walletNameList.length > 0 && !uiSelectedWalletId.value) {
        setUiSelectedWalletId((_a = walletNameList[0]) == null ? void 0 : _a.id, false);
      }
    });
    const doSelectWallet = (walletId) => {
      if (!walletId) {
        return;
      }
      setUiSelectedWalletId(walletId, selectedWalletId.value === walletId);
    };
    const onActivateAccount = (payload) => {
      console.log("!onActivateAccount - ", payload.walletId, payload.accountId);
      if (payload.walletId && payload.accountId) {
        doSelectWallet(payload.walletId);
        setUiSelectedWalletId(payload.walletId);
        console.log("!onActivateAccount - set ui selected", payload.accountId);
        setUiSelectedAccountId(payload.accountId);
      }
    };
    __expose({ onActivateAccount });
    const onSelectWalletInUi = (event) => {
      doSelectWallet(event.target.options[event.target.options.selectedIndex].value.toLowerCase());
    };
    onUnmounted(() => {
      resetSelection();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$6, [
        createVNode(_sfc_main$7, {
          label: unref(it)("dapps.accountSelection.headline")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$8, {
          text: unref(it)("dapps.accountSelection.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12"
        }),
        walletNameList.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_2$6, [
          createBaseVNode("div", _hoisted_3$6, [
            createVNode(_sfc_main$7, {
              class: "col-span-12",
              label: unref(it)("directconnect.connect.select.headline")
            }, null, 8, ["label"]),
            createBaseVNode("select", {
              class: "col-span-12 sm:col-span-6 xl:col-span-4 cc-rounded-la cc-dropdown cc-text-sm",
              required: true,
              onChange: _cache[0] || (_cache[0] = ($event) => onSelectWalletInUi($event))
            }, [
              (openBlock(true), createElementBlock(Fragment, null, renderList(walletNameList, (data) => {
                return openBlock(), createElementBlock("option", {
                  key: data.id,
                  selected: data.id === unref(uiSelectedWalletId),
                  value: data.id
                }, toDisplayString(data.name + (data.id === unref(dappWalletId) ? " (" + unref(it)("dapps.accountSelection.selectedWallet") + ")" : "")), 9, _hoisted_4$5);
              }), 128))
            ], 32)
          ])
        ])) : createCommentVNode("", true),
        unref(appWallet) && unref(appWallet).isReadOnly ? (openBlock(), createBlock(_sfc_main$9, {
          key: 1,
          icon: unref(it)("wallet.summary.setDAppAccount.warning.readOnly.icon"),
          text: unref(it)("wallet.summary.setDAppAccount.warning.readOnly.text"),
          class: "col-span-12",
          "text-c-s-s": "text-justify flex justify-start items-center",
          css: "cc-rounded cc-banner-warning"
        }, null, 8, ["icon", "text"])) : createCommentVNode("", true),
        createVNode(GridSpace, { hr: "" }),
        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(accountList), (account) => {
          return openBlock(), createBlock(_sfc_main$a, {
            key: "item_" + account.id,
            "account-id": account.id,
            "wallet-id": unref(uiSelectedWalletId),
            "is-selected-in-ui": account.id === unref(uiSelectedAccountId),
            "overwrite-show-stake": true,
            "preselect-dapp-account": false,
            onOnActivateAccount: onActivateAccount
          }, null, 8, ["account-id", "wallet-id", "is-selected-in-ui"]);
        }), 128))
      ]);
    };
  }
});
const _hoisted_1$5 = { class: "relative w-full flex flex-col flex-nowrap justify-between items-start pt-0.5 top-3.5 pb-3" };
const _hoisted_2$5 = { class: "grid grid-cols-12 w-full" };
const _hoisted_3$5 = { class: "col-span-6 cc-area-light-1 p-2 m-1" };
const _hoisted_4$4 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_5$3 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_6$3 = {
  key: 0,
  class: "col-span-6 cc-area-light-1 py-2 my-1 pl-2 ml-1"
};
const _hoisted_7$3 = { class: "w-full text-xs pr-2" };
const _hoisted_8$3 = { class: "w-full cc-text-bold justify-start" };
const _hoisted_9$2 = { class: "w-full cc-text-bold text-xs justify-start" };
const _hoisted_10$2 = ["href"];
const _hoisted_11$1 = {
  key: 0,
  class: "grid grid-cols-12 w-full"
};
const _hoisted_12$1 = { class: "col-span-12 cc-area-light-1 p-2 m-1" };
const _hoisted_13$1 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_14$1 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_15$1 = {
  key: 1,
  class: "grid grid-cols-12 w-full"
};
const _hoisted_16$1 = { class: "col-span-6 cc-area-light-1 p-2 m-1 overflow-x-scroll" };
const _hoisted_17$1 = { class: "col-span-12 text-xs" };
const _hoisted_18$1 = { class: "col-span-12 cc-text-bold justify-start" };
const _hoisted_19$1 = { class: "col-span-6 cc-area-light-1 py-2 my-1 pl-2 ml-1" };
const _hoisted_20$1 = { class: "col-span-12 text-xs" };
const _hoisted_21$1 = { class: "col-span-12 cc-text-bold justify-start overflow-x-scroll" };
const _hoisted_22$1 = { class: "grid grid-cols-12 w-full" };
const _hoisted_23$1 = { class: "col-span-6 cc-area-light-1 p-2 m-1" };
const _hoisted_24$1 = { class: "w-full grid grid-cols-12" };
const _hoisted_25$1 = { class: "col-span-6" };
const _hoisted_26$1 = { class: "w-full" };
const _hoisted_27$1 = { class: "w-full text-xs pr-2" };
const _hoisted_28$1 = { class: "w-full text-bold" };
const _hoisted_29$1 = { class: "w-full mt-2 text-xs" };
const _hoisted_30$1 = { class: "w-full text-xs pr-2" };
const _hoisted_31$1 = { class: "w-full text-bold" };
const _hoisted_32$1 = {
  key: 0,
  class: "col-span-6 flex justify-center items-center"
};
const _hoisted_33$1 = { class: "flex flex-col items-center" };
const _hoisted_34$1 = {
  class: "cc-text-bold flex-grow",
  id: "A2"
};
const _hoisted_35$1 = ["src"];
const _hoisted_36$1 = { class: "col-span-6 cc-area-light-1 py-2 my-1 pl-2 ml-1" };
const _hoisted_37$1 = { class: "w-full" };
const _hoisted_38$1 = { class: "w-full text-xs pr-2" };
const _hoisted_39 = { class: "w-full py-2 my-1" };
const _hoisted_40 = { class: "w-full col-span-12 grid grid-cols-12" };
const _hoisted_41 = { class: "col-span-4 cc-text-bold pr-2" };
const _hoisted_42 = { class: "col-span-8 justify-start" };
const _hoisted_43 = { class: "w-full col-span-12 grid grid-cols-12" };
const _hoisted_44 = { class: "col-span-4 cc-text-bold pr-2" };
const _hoisted_45 = { class: "col-span-8 justify-start" };
const _hoisted_46 = {
  key: 0,
  class: "w-full col-span-12 grid grid-cols-12"
};
const _hoisted_47 = { class: "col-span-4 cc-text-bold pr-2" };
const _hoisted_48 = { class: "col-span-8 justify-start" };
const _hoisted_49 = { class: "w-full col-span-12 grid grid-cols-12 justify-end" };
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "GridWalletConnectDetails",
  props: {
    wcInfo: { type: Object, required: true },
    showEdit: { type: Boolean, required: false, default: true },
    showDelete: { type: Boolean, required: false, default: true },
    showDisconnect: { type: Boolean, required: false, default: true }
  },
  emits: ["delete", "edit", "togglePeerConnection", "updateSession", "extendSession", "changeWallet", "ping"],
  setup(__props, { emit: __emit }) {
    var _a, _b, _c, _d, _e;
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { formatDatetime } = useFormatter();
    let walletConnect = useWalletConnect(ref(props.wcInfo.wcId));
    let walletName = "";
    let accountName = "";
    if (walletConnect) {
      const { walletConnectInfo } = walletConnect;
      if (walletConnectInfo.value && walletConnectInfo.value) {
        const {
          walletData,
          accountData
        } = useWalletAccount(ref(walletConnectInfo.value.walletId), ref(walletConnectInfo.value.accountId));
        walletName = ((_a = walletData.value) == null ? void 0 : _a.settings.name) ?? ((_c = (_b = walletData.value) == null ? void 0 : _b.wallet.legacySettings) == null ? void 0 : _c.name) ?? "unknown wallet";
        accountName = ((_d = accountData.value) == null ? void 0 : _d.settings.name) ?? "Account #" + String((_e = accountData.value) == null ? void 0 : _e.keys.path[2]) ?? "unknown account";
      }
    }
    const toggleConnection = (event) => {
      event.preventDefault();
      event.stopPropagation();
      emit("togglePeerConnection");
    };
    WalletConnectManager.getManager();
    return (_ctx, _cache) => {
      var _a2, _b2, _c2, _d2;
      return openBlock(), createElementBlock("div", _hoisted_1$5, [
        createBaseVNode("div", _hoisted_2$5, [
          createBaseVNode("div", _hoisted_3$5, [
            createBaseVNode("div", _hoisted_4$4, toDisplayString(unref(it)("directconnect.connect.label.status")), 1),
            createBaseVNode("div", _hoisted_5$3, toDisplayString(__props.wcInfo.active ? unref(it)("directconnect.connect.status.connected") : unref(it)("directconnect.connect.status.disconnected")), 1)
          ]),
          __props.wcInfo.dAppInfo ? (openBlock(), createElementBlock("div", _hoisted_6$3, [
            createBaseVNode("div", _hoisted_7$3, toDisplayString(unref(it)("directconnect.connect.labels.connectedTo")), 1),
            createBaseVNode("div", _hoisted_8$3, toDisplayString(__props.wcInfo.dAppInfo.name ?? ""), 1),
            createBaseVNode("div", _hoisted_9$2, [
              createBaseVNode("a", {
                href: (_a2 = __props.wcInfo.dAppInfo) == null ? void 0 : _a2.url,
                target: "_blank",
                rel: "noopener noreferrer",
                class: "flex flex-nowrap items-start justify-start flex-row"
              }, [
                createTextVNode(toDisplayString(__props.wcInfo.dAppInfo.url) + " ", 1),
                _cache[0] || (_cache[0] = createBaseVNode("i", { class: "mdi mdi-open-in-new ml-1" }, null, -1))
              ], 8, _hoisted_10$2)
            ])
          ])) : createCommentVNode("", true)
        ]),
        __props.wcInfo.connectError ? (openBlock(), createElementBlock("div", _hoisted_11$1, [
          createBaseVNode("div", _hoisted_12$1, [
            createBaseVNode("div", _hoisted_13$1, toDisplayString(unref(it)("walletconnect.connect.label.error")), 1),
            createBaseVNode("div", _hoisted_14$1, toDisplayString(__props.wcInfo.connectError), 1)
          ])
        ])) : createCommentVNode("", true),
        __props.wcInfo.session ? (openBlock(), createElementBlock("div", _hoisted_15$1, [
          createBaseVNode("div", _hoisted_16$1, [
            createBaseVNode("div", _hoisted_17$1, toDisplayString(unref(it)("directconnect.connect.labels.walletConnectionId")), 1),
            createBaseVNode("div", _hoisted_18$1, toDisplayString(__props.wcInfo.wcId), 1)
          ]),
          createBaseVNode("div", _hoisted_19$1, [
            createBaseVNode("div", _hoisted_20$1, toDisplayString(unref(it)("directconnect.connect.labels.address")), 1),
            createBaseVNode("div", _hoisted_21$1, toDisplayString(__props.wcInfo.session.topic), 1)
          ])
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_22$1, [
          createBaseVNode("div", _hoisted_23$1, [
            createBaseVNode("div", _hoisted_24$1, [
              createBaseVNode("div", _hoisted_25$1, [
                createBaseVNode("div", _hoisted_26$1, [
                  createBaseVNode("div", _hoisted_27$1, toDisplayString(unref(it)("directconnect.connect.labels.walletId")), 1)
                ]),
                createBaseVNode("div", _hoisted_28$1, toDisplayString(unref(walletName)), 1),
                createBaseVNode("div", _hoisted_29$1, [
                  createBaseVNode("div", _hoisted_30$1, toDisplayString(unref(it)("directconnect.connect.labels.accountPubKey")), 1)
                ]),
                createBaseVNode("div", _hoisted_31$1, toDisplayString(unref(accountName)), 1)
              ]),
              __props.wcInfo.dAppInfo ? (openBlock(), createElementBlock("div", _hoisted_32$1, [
                createBaseVNode("div", _hoisted_33$1, [
                  createBaseVNode("div", _hoisted_34$1, [
                    ((_b2 = __props.wcInfo.dAppInfo) == null ? void 0 : _b2.icons[0]) ? (openBlock(), createElementBlock("img", {
                      key: 0,
                      class: normalizeClass(__props.wcInfo.active ? "" : "grayscale"),
                      style: { "width": "100px", "height": "100px" },
                      src: (_c2 = __props.wcInfo.dAppInfo) == null ? void 0 : _c2.icons[0]
                    }, null, 10, _hoisted_35$1)) : createCommentVNode("", true)
                  ])
                ])
              ])) : createCommentVNode("", true)
            ])
          ]),
          createBaseVNode("div", _hoisted_36$1, [
            createBaseVNode("div", _hoisted_37$1, [
              createBaseVNode("div", _hoisted_38$1, toDisplayString(unref(it)("directconnect.connect.labels.info")), 1)
            ]),
            createBaseVNode("div", _hoisted_39, [
              createBaseVNode("div", _hoisted_40, [
                createBaseVNode("div", _hoisted_41, toDisplayString(unref(it)("directconnect.connect.labels.lastActive")), 1),
                createBaseVNode("div", _hoisted_42, toDisplayString(unref(formatDatetime)(__props.wcInfo.lastActive ?? 0)), 1)
              ]),
              createBaseVNode("div", _hoisted_43, [
                createBaseVNode("div", _hoisted_44, toDisplayString(unref(it)("directconnect.connect.labels.created")), 1),
                createBaseVNode("div", _hoisted_45, toDisplayString(unref(formatDatetime)(__props.wcInfo.created)), 1)
              ]),
              ((_d2 = __props.wcInfo.session) == null ? void 0 : _d2.expiry) ? (openBlock(), createElementBlock("div", _hoisted_46, [
                createBaseVNode("div", _hoisted_47, toDisplayString(unref(it)("walletconnect.connect.labels.expire")), 1),
                createBaseVNode("div", _hoisted_48, toDisplayString(unref(formatDatetime)(__props.wcInfo.session.expiry * 1e3)), 1)
              ])) : createCommentVNode("", true)
            ])
          ])
        ]),
        createBaseVNode("div", _hoisted_49, [
          props.showDisconnect && __props.wcInfo.active ? (openBlock(), createBlock(_sfc_main$b, {
            key: 0,
            label: unref(it)("directconnect.connect.label.disconnect"),
            onClick: toggleConnection,
            class: "col-start-4 col-span-12 md:col-start-4 md:col-span-3 m-2"
          }, null, 8, ["label"])) : createCommentVNode("", true),
          __props.showEdit ? (openBlock(), createBlock(_sfc_main$b, {
            key: 1,
            label: unref(it)("directconnect.connect.actions.edit"),
            link: () => emit("edit"),
            class: "col-start-0 col-span-12 md:col-start-7 md:col-span-3 m-2"
          }, null, 8, ["label", "link"])) : createCommentVNode("", true),
          __props.showDelete ? (openBlock(), createBlock(_sfc_main$b, {
            key: 2,
            label: unref(it)("directconnect.connect.actions.delete"),
            link: () => emit("delete"),
            class: "col-start-0 col-span-12 md:col-start-10 md:col-span-3 m-2"
          }, null, 8, ["label", "link"])) : createCommentVNode("", true)
        ])
      ]);
    };
  }
});
const _hoisted_1$4 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$4 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$4 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_4$3 = { class: "flex flex-col cc-text" };
const _hoisted_5$2 = { class: "grid grid-cols-12 w-full" };
const _hoisted_6$2 = { class: "col-span-12 cc-area-light-1 p-2 m-1" };
const _hoisted_7$2 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_8$2 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_9$1 = { class: "grid grid-cols-12 w-full" };
const _hoisted_10$1 = { class: "col-span-12 cc-area-light-1 p-2 m-1" };
const _hoisted_11 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_12 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_13 = { class: "grid grid-cols-12 w-full" };
const _hoisted_14 = { class: "col-span-12 cc-area-light-1 p-2 m-1" };
const _hoisted_15 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_16 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_17 = { class: "grid grid-cols-12 w-full" };
const _hoisted_18 = { class: "col-span-12 cc-area-highlight-1 p-2 m-1" };
const _hoisted_19 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_20 = { class: "grid grid-cols-12 w-full" };
const _hoisted_21 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 cc-area-light-1 p-2 m-1"
};
const _hoisted_22 = { class: "col-span-1 p-2 m-1" };
const _hoisted_23 = { class: "col-span-11 p-2" };
const _hoisted_24 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_25 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_26 = { class: "col-span-12 cc-area-light-1 p-2 m-1" };
const _hoisted_27 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_28 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_29 = { key: 0 };
const _hoisted_30 = { class: "grid grid-cols-12 w-full" };
const _hoisted_31 = { class: "col-span-12 cc-area-light-1 p-2 m-1" };
const _hoisted_32 = { class: "col-span-4 text-xs pr-2 w-auto h-auto" };
const _hoisted_33 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_34 = { class: "grid grid-cols-12 w-full" };
const _hoisted_35 = { class: "col-span-12 cc-area-light-1 p-2 m-1" };
const _hoisted_36 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_37 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_38 = { class: "grid grid-cols-12 cc-gap p-2 w-full" };
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "WalletConnectProposalModal",
  props: {
    proposal: { type: Object, required: true },
    showModal: { type: Object, required: true },
    textId: { type: String, required: false, default: void 0 },
    title: { type: String, required: false, default: void 0 },
    caption: { type: String, required: false, default: void 0 },
    modalCSS: { type: String, required: false, default: void 0 },
    scrollable: { type: Boolean, required: false, default: false },
    persistent: { type: Boolean, required: false, default: false },
    repeatPassword: { type: Boolean, required: false, default: false },
    validatePassword: { type: Boolean, required: false, default: false },
    cancelLabel: { type: String, required: false, default: void 0 },
    confirmLabel: { type: String, required: false, default: void 0 }
  },
  emits: ["close", "confirm", "cancel"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { showModal } = toRefs(props);
    const cancelLabel = ref(props.cancelLabel);
    const confirmLabel = ref(props.confirmLabel);
    const proposalChain = computed(() => {
      var _a;
      let chains = (_a = props.proposal) == null ? void 0 : _a.params.requiredNamespaces["cip34"].chains;
      let chainMagic = null;
      let chain = "Mainnet";
      if ((chains == null ? void 0 : chains.length) === 1) {
        chainMagic = chains[0].split("-")[1] ?? null;
        console.log("chain magis is", chainMagic, chains);
        if (chainMagic === "1") {
          chain = "Preprod";
        } else if (chainMagic === "2") {
          chain = "Preview";
        }
      }
      return (chains == null ? void 0 : chains.join(", ")) + ` (${chain})`;
    });
    const proposalMethods = computed(() => {
      var _a, _b;
      return ((_b = (_a = props.proposal) == null ? void 0 : _a.params.requiredNamespaces["cip34"].methods) == null ? void 0 : _b.join(", ")) ?? "";
    });
    const proposalEvents = computed(() => {
      var _a, _b;
      return ((_b = (_a = props.proposal) == null ? void 0 : _a.params.requiredNamespaces["cip34"].events) == null ? void 0 : _b.join(", ")) ?? "";
    });
    const wrongNetwork = computed(() => {
      var _a;
      let chains = (_a = props.proposal) == null ? void 0 : _a.params.requiredNamespaces["cip34"].chains;
      let chainMagic = null;
      if ((chains == null ? void 0 : chains.length) === 1) {
        chainMagic = chains[0].split("-")[1] ?? null;
      }
      if (chainMagic && (chainMagic === "1" && networkId.value !== "preprod") || chainMagic === "2" && networkId.value !== "preview" || chainMagic === "764824073" && networkId.value !== "mainnet") {
        return true;
      }
      return false;
    });
    if (props.cancelLabel === void 0) {
      cancelLabel.value = it("common.label.cancel");
    }
    if (props.confirmLabel === void 0) {
      confirmLabel.value = it("common.label.confirm");
    }
    const onConfirm = () => {
      emit("confirm");
    };
    const onCancel = () => {
      showModal.value.display = false;
      emit("cancel");
    };
    const onClose = () => {
      showModal.value.display = false;
      emit("close");
    };
    return (_ctx, _cache) => {
      var _a;
      return ((_a = unref(showModal)) == null ? void 0 : _a.display) ? (openBlock(), createBlock(Modal, {
        key: 0,
        narrow: "",
        "full-width-on-mobile": "",
        onClose
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1$4, [
            createBaseVNode("div", _hoisted_2$4, [
              createVNode(_sfc_main$7, {
                label: unref(it)("walletconnect.connect.modal.headline")
              }, null, 8, ["label"])
            ])
          ]),
          createBaseVNode("div", _hoisted_3$4, [
            createBaseVNode("div", _hoisted_4$3, toDisplayString(unref(it)("walletconnect.connect.modal.info")), 1)
          ])
        ]),
        content: withCtx(() => {
          var _a2, _b, _c;
          return [
            createBaseVNode("div", _hoisted_5$2, [
              createBaseVNode("div", _hoisted_6$2, [
                createBaseVNode("div", _hoisted_7$2, toDisplayString(unref(it)("walletconnect.connect.modal.name")), 1),
                createBaseVNode("div", _hoisted_8$2, toDisplayString((_a2 = __props.proposal) == null ? void 0 : _a2.params.proposer.metadata.name), 1)
              ])
            ]),
            createBaseVNode("div", _hoisted_9$1, [
              createBaseVNode("div", _hoisted_10$1, [
                createBaseVNode("div", _hoisted_11, toDisplayString(unref(it)("walletconnect.connect.modal.url")), 1),
                createBaseVNode("div", _hoisted_12, toDisplayString((_b = __props.proposal) == null ? void 0 : _b.params.proposer.metadata.url), 1)
              ])
            ]),
            createBaseVNode("div", _hoisted_13, [
              createBaseVNode("div", _hoisted_14, [
                createBaseVNode("div", _hoisted_15, toDisplayString(unref(it)("walletconnect.connect.modal.topic")), 1),
                createBaseVNode("div", _hoisted_16, toDisplayString((_c = __props.proposal) == null ? void 0 : _c.params.pairingTopic), 1)
              ])
            ]),
            createBaseVNode("div", _hoisted_17, [
              createBaseVNode("div", _hoisted_18, [
                createBaseVNode("div", _hoisted_19, toDisplayString(unref(it)("walletconnect.connect.modal.request")), 1)
              ])
            ]),
            createBaseVNode("div", _hoisted_20, [
              wrongNetwork.value ? (openBlock(), createElementBlock("div", _hoisted_21, [
                createBaseVNode("div", _hoisted_22, [
                  createVNode(IconWarning, { class: "w-7 flex-none mr-2" })
                ]),
                createBaseVNode("div", _hoisted_23, [
                  createBaseVNode("div", _hoisted_24, toDisplayString(unref(it)("walletconnect.connect.modal.networkWarning.label")), 1),
                  createBaseVNode("div", _hoisted_25, toDisplayString(unref(it)("walletconnect.connect.modal.networkWarning.info")), 1)
                ])
              ])) : createCommentVNode("", true),
              createBaseVNode("div", _hoisted_26, [
                createBaseVNode("div", _hoisted_27, toDisplayString(unref(it)("walletconnect.connect.modal.namespace")), 1),
                createBaseVNode("div", _hoisted_28, toDisplayString(proposalChain.value), 1)
              ])
            ]),
            !wrongNetwork.value ? (openBlock(), createElementBlock("div", _hoisted_29, [
              createBaseVNode("div", _hoisted_30, [
                createBaseVNode("div", _hoisted_31, [
                  createBaseVNode("div", _hoisted_32, toDisplayString(unref(it)("walletconnect.connect.modal.methods")), 1),
                  createBaseVNode("div", _hoisted_33, toDisplayString(proposalMethods.value), 1)
                ])
              ]),
              createBaseVNode("div", _hoisted_34, [
                createBaseVNode("div", _hoisted_35, [
                  createBaseVNode("div", _hoisted_36, toDisplayString(unref(it)("walletconnect.connect.modal.events")), 1),
                  createBaseVNode("div", _hoisted_37, toDisplayString(proposalEvents.value), 1)
                ])
              ])
            ])) : createCommentVNode("", true)
          ];
        }),
        footer: withCtx(() => [
          createBaseVNode("div", _hoisted_38, [
            createVNode(GridButtonSecondary, {
              label: cancelLabel.value,
              link: onCancel,
              class: "col-start-0 col-span-6 lg:col-start-0 lg:col-span-4"
            }, null, 8, ["label"]),
            createVNode(_sfc_main$b, {
              disabled: wrongNetwork.value,
              label: confirmLabel.value,
              link: onConfirm,
              class: "col-span-6 lg:col-start-9 lg:col-span-4"
            }, null, 8, ["disabled", "label"])
          ])
        ]),
        _: 1
      })) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$3 = { class: "cc-grid" };
const _hoisted_2$3 = { key: 0 };
const _hoisted_3$3 = { class: "relative w-full grid grid-cols-12 gap-2 col-span-12" };
const _hoisted_4$2 = { class: "col-span-10 md:col-span-11" };
const _hoisted_5$1 = { class: "col-span-2 md:col-span-1" };
const _hoisted_6$1 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12"
};
const _hoisted_7$1 = {
  key: 1,
  class: "col-span-12 grid grid-cols-12"
};
const _hoisted_8$1 = {
  key: 2,
  class: "col-span-12 grid grid-cols-12"
};
const _hoisted_9 = {
  key: 3,
  class: "col-span-12"
};
const _hoisted_10 = {
  key: 4,
  class: "col-span-12"
};
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "DAppsWalletConnect",
  props: {
    entry: { type: Object, required: false }
  },
  setup(__props) {
    var _a;
    const props = __props;
    const { it } = useTranslation();
    const {
      uiSelectedWalletId,
      uiSelectedAccountId,
      setUiSelectedWalletId,
      setUiSelectedAccountId
    } = useUiSelectedAccount();
    const peerAccountList = ref(null);
    const $q = useQuasar();
    const dAppIdentifier = ref(((_a = props.entry) == null ? void 0 : _a.wcId) ?? "");
    const inputError = ref("");
    const walletConnectionId = ref(null);
    const wcInfo = ref(null);
    const inEdit = ref(false);
    const isValidConnectId = ref(false);
    const confirmCallback = ref((_confirmed) => {
    });
    const showProposalModal = ref({ display: false });
    const proposal = ref(null);
    const {
      walletData,
      accountData
    } = useWalletAccount(uiSelectedWalletId, uiSelectedAccountId);
    const setProposal = (prop, confirmCall) => {
      proposal.value = prop;
      confirmCallback.value = confirmCall;
      showProposalModal.value.display = true;
    };
    onMounted(async () => {
      await manager.setProposalCallback(networkId.value, setProposal);
    });
    const confirmConnect = () => {
      confirmCallback.value(true);
      showProposalModal.value.display = false;
    };
    const denyConnect = () => {
      confirmCallback.value(false);
      showProposalModal.value.display = false;
    };
    const manager = WalletConnectManager.getManager();
    if (!manager.quasar) {
      manager.setQuasar($q);
    }
    const checkInputString = (_event) => {
      checkInput(dAppIdentifier.value);
    };
    const checkInput = async (dappId, _loadFromDb = false) => {
      dAppIdentifier.value = dappId;
      const tmp = buildWalletConnectParams(dAppIdentifier.value);
      const walletConnect = useWalletConnect(ref(dappId));
      if (walletConnect) {
        const { walletConnectInfo } = walletConnect;
        if (walletConnectInfo.value) {
          inputError.value = "";
          isValidConnectId.value = true;
          return;
        } else {
          console.log("no peer connect info found");
        }
      }
      if (tmp) {
        walletConnectionId.value = tmp.id;
        inputError.value = "";
        isValidConnectId.value = true;
      } else {
        inputError.value = it("walletconnect.connect.status.invalidAddress");
        isValidConnectId.value = false;
      }
      if (!uiSelectedWalletId.value || !uiSelectedAccountId.value) {
        inputError.value = it("walletconnect.connect.status.noaccount");
        return;
      }
    };
    watch(uiSelectedAccountId, () => {
      checkInput(dAppIdentifier.value, false);
      if (inEdit && (wcInfo.value && wcInfo.value.accountId !== uiSelectedAccountId.value)) {
        saveChanges();
      }
    });
    const showConnectionInfo = () => {
      var _a2, _b;
      if (wcInfo.value) {
        setUiSelectedWalletId((_a2 = wcInfo.value) == null ? void 0 : _a2.walletId);
        setUiSelectedAccountId((_b = wcInfo.value) == null ? void 0 : _b.accountId);
      }
    };
    watch(() => wcInfo.value, () => {
      showConnectionInfo();
    }, { deep: true });
    watch(() => dAppIdentifier.value, () => {
      showConnectionInfo();
    });
    showConnectionInfo();
    const connect = async () => {
      var _a2;
      if (!walletData.value) {
        throw new Error("You need to set the wallet.");
      }
      if (!accountData.value) {
        throw new Error("You need to set the dapp account.");
      }
      const params = buildWalletConnectParams(dAppIdentifier.value);
      if (!params) {
        throw new Error("NO topic found in connection string.");
      }
      await manager.initConnection(
        networkId.value,
        walletData.value,
        accountData.value,
        params
      );
      wcInfo.value = (_a2 = useWalletConnect(ref(params.id))) == null ? void 0 : _a2.walletConnectInfo.value;
    };
    const disconnect = () => {
      if (!wcInfo.value) {
        return;
      }
      try {
        manager.disconnect(wcInfo.value.wcId);
      } catch (e) {
        console.error("Error on disconnect:", e);
      }
    };
    const onQrCode = (payload) => {
      let code = payload.content;
      checkInput(code, true);
    };
    const reset = () => {
      dAppIdentifier.value = "";
    };
    const onPaste = async (e) => {
      var _a2;
      e.stopPropagation();
      e.preventDefault();
      let clipboardData = ((_a2 = e.clipboardData) == null ? void 0 : _a2.getData("Text")) ?? "";
      await checkInput(clipboardData, true);
    };
    const saveChanges = async () => {
      var _a2, _b;
      if (((_a2 = props.entry) == null ? void 0 : _a2.accountId) === uiSelectedAccountId.value) {
        return;
      }
      if (!props.entry || !props.entry.wcId) {
        return;
      }
      const peerInfoForConnection = (_b = useWalletConnect(ref(props.entry.wcId))) == null ? void 0 : _b.walletConnectInfo;
      if (!(peerInfoForConnection == null ? void 0 : peerInfoForConnection.value)) {
        return;
      }
      if (!uiSelectedWalletId.value || !uiSelectedAccountId.value) {
        return;
      }
      if (peerInfoForConnection.value) {
        peerInfoForConnection.value.walletId = uiSelectedWalletId.value;
        peerInfoForConnection.value.accountId = uiSelectedAccountId.value;
        await saveWalletConnect(peerInfoForConnection.value);
        if (!uiSelectedWalletId.value || !uiSelectedAccountId.value) {
          return;
        }
        if (!walletData.value || !accountData.value) {
          return;
        }
        await manager.injectNewApi(peerInfoForConnection.value, walletData.value, accountData.value);
      }
      return;
    };
    onMounted(() => {
      var _a2, _b;
      if ((_a2 = props.entry) == null ? void 0 : _a2.wcId) {
        const walletConnect = useWalletConnect(ref(props.entry ? (_b = props.entry) == null ? void 0 : _b.wcId : dAppIdentifier.value));
        if (walletConnect) {
          const { walletConnectInfo } = walletConnect;
          inEdit.value = true;
          if (walletConnectInfo.value) {
            wcInfo.value = walletConnectInfo.value;
            walletConnectionId.value = walletConnectInfo.value.wcId;
            setUiSelectedWalletId(walletConnectInfo.value.walletId);
            setUiSelectedAccountId(walletConnectInfo.value.accountId);
          }
        }
      }
    });
    return (_ctx, _cache) => {
      var _a2, _b, _c;
      return openBlock(), createElementBlock("div", _hoisted_1$3, [
        showProposalModal.value.display ? (openBlock(), createElementBlock("div", _hoisted_2$3, [
          createVNode(_sfc_main$4, {
            "show-modal": showProposalModal.value,
            proposal: proposal.value,
            onConfirm: confirmConnect,
            onCancel: denyConnect,
            onClose: denyConnect
          }, null, 8, ["show-modal", "proposal"])
        ])) : createCommentVNode("", true),
        createVNode(_sfc_main$7, {
          label: unref(it)("walletconnect.connect.headline"),
          "do-capitalize": false
        }, null, 8, ["label"]),
        createVNode(_sfc_main$8, {
          text: unref(it)("walletconnect.connect.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, { hr: "" }),
        createBaseVNode("div", _hoisted_3$3, [
          createBaseVNode("div", _hoisted_4$2, [
            createVNode(GridInput, {
              "input-text": dAppIdentifier.value,
              "onUpdate:inputText": [
                _cache[0] || (_cache[0] = ($event) => dAppIdentifier.value = $event),
                checkInputString
              ],
              onInput: checkInputString,
              onEnter: connect,
              onReset: reset,
              onPaste,
              "input-disabled": inEdit.value,
              "input-hint": unref(it)("walletconnect.connect.identifier.hint"),
              "input-c-s-s": "cc-input",
              autofocus: true,
              showReset: !inEdit.value,
              "input-error": inputError.value,
              "input-id": "dAppIdentifierId",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              _: 1
            }, 8, ["input-text", "input-disabled", "input-hint", "showReset", "input-error"])
          ]),
          createBaseVNode("div", _hoisted_5$1, [
            createVNode(_sfc_main$c, {
              onDecode: onQrCode,
              class: "relative w-full h-full flex flex-row flex-nowrap justify-center items-center cursor-pointer focus:outline-none text-sm cc-text-bold cc-btn-secondary"
            })
          ]),
          !((_a2 = wcInfo.value) == null ? void 0 : _a2.active) && !inEdit.value ? (openBlock(), createElementBlock("div", _hoisted_6$1, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("common.label.connectDApp"),
              link: connect,
              type: "button",
              disabled: !isValidConnectId.value,
              class: "col-start-9 col-span-4"
            }, null, 8, ["label", "disabled"])
          ])) : createCommentVNode("", true),
          ((_b = wcInfo.value) == null ? void 0 : _b.active) ? (openBlock(), createElementBlock("div", _hoisted_7$1, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("common.label.disconnect"),
              link: disconnect,
              type: "button",
              class: "col-start-9 col-span-4"
            }, null, 8, ["label"])
          ])) : createCommentVNode("", true),
          inEdit.value ? (openBlock(), createElementBlock("div", _hoisted_8$1, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("common.label.save"),
              disabled: ((_c = wcInfo.value) == null ? void 0 : _c.accountId) === unref(uiSelectedAccountId),
              link: saveChanges,
              type: "button",
              class: "col-start-9 col-span-4"
            }, null, 8, ["label", "disabled"])
          ])) : createCommentVNode("", true),
          walletConnectionId.value && wcInfo.value ? (openBlock(), createElementBlock("div", _hoisted_9, [
            createVNode(_sfc_main$5, {
              "wc-info": wcInfo.value,
              "show-edit": false,
              "show-delete": false,
              "show-disconnect": false
            }, null, 8, ["wc-info"])
          ])) : createCommentVNode("", true),
          unref(walletsExists) ? (openBlock(), createElementBlock("div", _hoisted_10, [
            createVNode(_sfc_main$6, {
              ref_key: "peerAccountList",
              ref: peerAccountList
            }, null, 512)
          ])) : createCommentVNode("", true)
        ])
      ]);
    };
  }
});
const _hoisted_1$2 = { class: "h-full pr-1 flex flex-col self-start" };
const _hoisted_2$2 = { class: "cc-flex-fixed flex flex-row flex-nowrap items-start" };
const _hoisted_3$2 = { class: "relative cc-flex-fixed flex flex-col flex-nowrap items-start w-6 h-6 -ml-1" };
const _hoisted_4$1 = { class: "relative cc-text-bold mr-0.5" };
const _hoisted_5 = { class: "ml-6 mt-1 cc-addr break-normal" };
const _hoisted_6 = { class: "relative col items-center w-full max-w-full" };
const _hoisted_7 = {
  key: 0,
  class: "w-10 h-10 flex flex-row flex-nowrap justify-end items-center"
};
const _hoisted_8 = {
  key: 1,
  class: "w-10 h-10 flex flex-row flex-nowrap justify-end items-center"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GridWalletConnectListEntry",
  props: {
    entry: { type: Object, required: true }
  },
  emits: ["delete", "edit"],
  setup(__props, { emit: __emit }) {
    var _a, _b, _c, _d, _e, _f, _g;
    const emit = __emit;
    const props = __props;
    const { entry } = toRefs(props);
    const walletId = ref(((_a = entry == null ? void 0 : entry.value) == null ? void 0 : _a.walletId) ?? null);
    const accountId = ref(((_b = entry == null ? void 0 : entry.value) == null ? void 0 : _b.accountId) ?? null);
    watch(entry, (value) => {
      if (value) {
        walletId.value = value.walletId;
        accountId.value = value.accountId;
      }
    });
    const {
      accountData,
      walletData
    } = useWalletAccount(ref(walletId), ref(accountId));
    const stakeKey = (_c = accountData.value) == null ? void 0 : _c.keys.stake[0];
    (_d = accountData.value) == null ? void 0 : _d.settings.name;
    (_e = walletData.value) == null ? void 0 : _e.settings.name;
    const { it, c } = useTranslation();
    const open = ref(false);
    useQuasar();
    const log = (...entries) => {
    };
    const walletConnectInfo = (_g = useWalletConnect(ref((_f = props.entry) == null ? void 0 : _f.wcId))) == null ? void 0 : _g.walletConnectInfo;
    const quasar = useQuasar();
    const toggleAutoConnect = async () => {
      console.log("toggle autoconnect!");
      if (!(walletConnectInfo == null ? void 0 : walletConnectInfo.value)) {
        return;
      }
    };
    let manager = null;
    onBeforeMount(() => {
      manager = WalletConnectManager.getManager();
    });
    const deleteEntry = async () => {
      if (!networkId.value) return;
      manager == null ? void 0 : manager.deleteConnection(props.entry);
      nextTick(() => {
        emit("delete");
      });
    };
    const editEntry = async () => {
      if (!networkId.value) return;
      emit("edit", { entry: props.entry });
    };
    const extendSession = () => {
      var _a2, _b2;
      if (!walletData.value) {
        throw new Error("You need to set the wallet.");
      }
      if (!accountData.value) {
        throw new Error("You need to set the dapp account.");
      }
      manager == null ? void 0 : manager.extendSession(networkId.value, walletData.value, accountData.value, (_b2 = (_a2 = props.entry) == null ? void 0 : _a2.session) == null ? void 0 : _b2.topic);
    };
    const updateSession = () => {
      const stakeInfoKey = getRewardAddressFromCred(stakeKey.cred, networkId.value);
      if (!walletData.value) {
        throw new Error("You need to set the wallet.");
      }
      if (!accountData.value) {
        throw new Error("You need to set the dapp account.");
      }
      manager == null ? void 0 : manager.updateSession(networkId.value, walletData.value, accountData.value, props.entry, stakeInfoKey);
    };
    const changeWallet = () => {
      const stakeInfoKey = getRewardAddressFromCred(stakeKey.cred, networkId.value);
      if (!walletData.value) {
        throw new Error("You need to set the wallet.");
      }
      if (!accountData.value) {
        throw new Error("You need to set the dapp account.");
      }
      manager == null ? void 0 : manager.changeWallet(networkId.value, walletData.value, accountData.value, props.entry, stakeInfoKey.slice(0, -1) + "A");
    };
    const ping = () => {
      const stakeInfoKey = getRewardAddressFromCred(stakeKey.cred, networkId.value);
      if (!walletData.value) {
        throw new Error("You need to set the wallet.");
      }
      if (!accountData.value) {
        throw new Error("You need to set the dapp account.");
      }
      manager == null ? void 0 : manager.ping(networkId.value, props.entry, stakeInfoKey.slice(0, -1) + "A");
    };
    const toggleConnection = (event) => {
      var _a2;
      log("toggle connection coming from detail in list view", walletConnectInfo == null ? void 0 : walletConnectInfo.value);
      if (event instanceof Event) {
        event.preventDefault();
        event.stopPropagation();
      }
      if (walletConnectInfo && walletConnectInfo.value && walletConnectInfo.value.active) {
        try {
          manager == null ? void 0 : manager.disconnect((_a2 = props.entry) == null ? void 0 : _a2.wcId);
        } catch (e) {
          if (e.message && e.message.includes("not seen - no public key")) {
            quasar.notify({
              type: "warning",
              message: "Connection endpoint is not available. Reload the DApp window and try again.",
              position: "top-left"
            });
          }
        }
      }
    };
    return (_ctx, _cache) => {
      var _a2, _b2, _c2, _d2, _e2, _f2, _g2, _h;
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", {
          class: normalizeClass(["col-span-12 cc-p pt-1.5 cc-text-sz flex flex-col flex-grow flex-nowrap", open.value ? "cc-area-light" : ""])
        }, [
          createBaseVNode("div", {
            class: "flex flex-row flex-nowrap justify-between items-start cursor-pointer",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => open.value = !open.value, ["stop"]))
          }, [
            createBaseVNode("div", _hoisted_1$2, [
              createBaseVNode("div", _hoisted_2$2, [
                createBaseVNode("div", _hoisted_3$2, [
                  _cache[1] || (_cache[1] = createBaseVNode("i", { class: "relative text-xl mt-0 mdi mdi-application" }, null, -1)),
                  createBaseVNode("i", {
                    class: normalizeClass(["relative text-xl -top-2", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
                  }, null, 2)
                ]),
                createBaseVNode("div", {
                  class: normalizeClass(["relative flex flex-row items-center mt-1 sm:mt-0.5 space-x-1 ml-1", open.value ? " " : " "])
                }, [
                  createBaseVNode("div", _hoisted_4$1, toDisplayString((_b2 = (_a2 = unref(walletConnectInfo)) == null ? void 0 : _a2.dAppInfo) == null ? void 0 : _b2.name), 1),
                  createBaseVNode("div", null, [
                    createBaseVNode("div", {
                      class: normalizeClass(["cc-none inline-flex justify-center", ((_c2 = unref(walletConnectInfo)) == null ? void 0 : _c2.active) ? "cc-badge-green" : "cc-badge-yellow"])
                    }, [
                      createTextVNode(toDisplayString(((_d2 = unref(walletConnectInfo)) == null ? void 0 : _d2.active) ? unref(it)("directconnect.connect.status.connected") : unref(it)("directconnect.connect.status.disconnected")) + " ", 1),
                      createVNode(_sfc_main$d, {
                        anchor: "center right",
                        self: "center left",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => {
                          var _a3;
                          return [
                            createTextVNode(toDisplayString(((_a3 = unref(walletConnectInfo)) == null ? void 0 : _a3.active) ? unref(it)("directconnect.connect.badge.connected") : unref(it)("directconnect.connect.badge.disconnected")), 1)
                          ];
                        }),
                        _: 1
                      })
                    ], 2)
                  ])
                ], 2)
              ]),
              createBaseVNode("div", _hoisted_5, toDisplayString((_f2 = (_e2 = unref(walletConnectInfo)) == null ? void 0 : _e2.dAppInfo) == null ? void 0 : _f2.url), 1)
            ]),
            createBaseVNode("div", {
              class: "inline-flex items-top self-start justify-center pt-1 relative",
              onClick: toggleConnection
            }, [
              createBaseVNode("div", _hoisted_6, [
                ((_g2 = unref(walletConnectInfo)) == null ? void 0 : _g2.active) ? (openBlock(), createElementBlock("div", _hoisted_7, [
                  _cache[2] || (_cache[2] = createBaseVNode("button", {
                    type: "button",
                    "aria-label": "sync wallet",
                    class: "relative h-full text-md sm:text-xl px-2.5 flex flex-col justify-center items-center cursor-pointer cc-text-highlight-hover"
                  }, [
                    createBaseVNode("svg", {
                      xmlns: "http://www.w3.org/2000/svg",
                      viewBox: "0 0 24 24",
                      class: "cc-fill-green w-full h-full -ml-1"
                    }, [
                      createBaseVNode("path", { d: "M 20.59375 2 L 17.09375 5.5 L 15.1875 3.59375 C 14.3875 2.79375 13.20625 2.79375 12.40625 3.59375 L 9.90625 6.09375\n  L 8.90625 5.09375 L 7.5 6.5 L 17.5 16.5 L 18.90625 15.09375 L 17.90625 14.09375\n  L 20.40625 11.59375 C 21.20625 10.79375 21.20625 9.6125 20.40625 8.8125 L 18.5 6.90625\n  L 22 3.40625 L 20.59375 2 z M 6.40625 7.59375 L 5 9 L 6 10 L 3.59375 12.40625 C 2.79375 13.20625 2.79375 14.3875 3.59375 15.1875\n  L 5.5 17.09375 L 2 20.59375 L 3.40625 22 L 6.90625 18.5 L 8.8125 20.40625 C 9.6125 21.20625 10.79375 21.20625 11.59375 20.40625\n  L 14 18 L 15 19 L 16.40625 17.59375 L 6.40625 7.59375 z" })
                    ]),
                    createBaseVNode("i", { class: "cc-text-green text-xs relative top-3 -left-2" }, "P2P")
                  ], -1)),
                  createVNode(_sfc_main$d, {
                    anchor: "center right",
                    self: "center left",
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(it)("directconnect.connect.actions.disconnect")), 1)
                    ]),
                    _: 1
                  })
                ])) : createCommentVNode("", true),
                !((_h = unref(walletConnectInfo)) == null ? void 0 : _h.active) ? (openBlock(), createElementBlock("div", _hoisted_8, [
                  _cache[3] || (_cache[3] = createBaseVNode("button", {
                    type: "button",
                    "aria-label": "sync wallet",
                    class: "relative h-full text-md sm:text-xl px-2.5 flex flex-col justify-center items-center cursor-pointer cc-text-highlight-hover"
                  }, [
                    createBaseVNode("svg", {
                      xmlns: "http://www.w3.org/2000/svg",
                      viewBox: "0 0 24 24",
                      class: "cc-fill w-full h-full -ml-1"
                    }, [
                      createBaseVNode("path", { d: "M 14.8125 2 C 14.3125 2 13.80625 2.19375 13.40625 2.59375 L 11.90625 4.09375 L 10.90625 3.09375 L 9.5 4.5\n  L 11.8125 6.8125 L 9.1875 9.40625 L 10.59375 10.8125 L 13.1875 8.1875 L 15.8125 10.8125 L 13.1875 13.40625\n  L 14.59375 14.8125 L 17.1875 12.1875 L 19.5 14.5 L 20.90625 13.09375 L 19.90625 12.09375 L 21.40625 10.59375\n  C 22.20625 9.79375 22.20625 8.6125 21.40625 7.8125 L 19.5 5.90625 L 22 3.40625 L 20.59375 2 L 18.09375 4.5\n  L 16.1875 2.59375 C 15.7875 2.19375 15.3125 2 14.8125 2 z M 4.40625 9.59375 L 3 11 L 4 12 L 2.59375 13.40625\n  C 1.79375 14.20625 1.79375 15.3875 2.59375 16.1875 L 4.5 18.09375 L 2 20.59375 L 3.40625 22 L 5.90625 19.5\n  L 7.8125 21.40625 C 8.6125 22.20625 9.79375 22.20625 10.59375 21.40625 L 12 20 L 13 21 L 14.40625 19.59375 L 4.40625 9.59375 z" })
                    ]),
                    createBaseVNode("i", { class: "text-xs relative top-3 -left-2" }, "P2P")
                  ], -1)),
                  createVNode(_sfc_main$d, {
                    anchor: "center right",
                    self: "center left",
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(it)("directconnect.connect.actions.connect")), 1)
                    ]),
                    _: 1
                  })
                ])) : createCommentVNode("", true)
              ])
            ])
          ]),
          open.value && unref(walletConnectInfo) ? (openBlock(), createBlock(_sfc_main$5, {
            key: 0,
            "wc-info": unref(walletConnectInfo),
            onTogglePeerConnection: toggleConnection,
            onToggleAutoConnect: toggleAutoConnect,
            onExtendSession: extendSession,
            onUpdateSession: updateSession,
            onChangeWallet: changeWallet,
            onPing: ping,
            onEdit: editEntry,
            onDelete: deleteEntry
          }, null, 8, ["wc-info"])) : createCommentVNode("", true)
        ], 2),
        createVNode(GridSpace, { hr: "" })
      ], 64);
    };
  }
});
const _hoisted_1$1 = { class: "cc-grid" };
const _hoisted_2$1 = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_3$1 = {
  key: 0,
  class: "col-span-12 cc-p pt-1.5 cc-text-sz flex flex-col flex-grow flex-nowrap items-center"
};
const _hoisted_4 = { class: "col-span-12 flex justify-center" };
const itemsOnPage = 10;
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "DAppsWalletConnectManager",
  emits: ["edit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    useTranslation();
    const currentPage = ref(1);
    const showPagination = computed(() => walletConnectDBList.length > itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const maxPages = computed(() => Math.ceil(walletConnectDBList.length / itemsOnPage));
    onBeforeMount(async () => {
      await reloadEntries();
    });
    const reloadEntries = async () => {
      if (!networkId.value) {
        return;
      }
      await updateWalletConnectList(networkId.value, true);
    };
    const pagedPeerConnections = computed(() => walletConnectDBList.slice(currentPageStart.value, currentPageStart.value + itemsOnPage));
    const editEntry = (event) => {
      emit("edit", event);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createBaseVNode("div", _hoisted_2$1, [
          (openBlock(true), createElementBlock(Fragment, null, renderList(pagedPeerConnections.value, (item) => {
            return openBlock(), createBlock(_sfc_main$2, {
              key: item.wcId,
              entry: item,
              onDelete: reloadEntries,
              onEdit: editEntry
            }, null, 8, ["entry"]);
          }), 128)),
          pagedPeerConnections.value.length === 0 ? (openBlock(), createElementBlock("div", _hoisted_3$1, " No direct connect connections created. ")) : createCommentVNode("", true)
        ]),
        createBaseVNode("div", _hoisted_4, [
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
      ]);
    };
  }
});
const _hoisted_1 = { class: "relative w-full h-full cc-rounded flex flex-row-reverse flex-nowrap dark:text-cc-gray-dark" };
const _hoisted_2 = { class: "relative h-full flex-1 overflow-hidden focus:outline-none flex flex-col flex-nowrap" };
const _hoisted_3 = { class: "cc-page-wallet cc-text-sz dark:text-cc-gray mb-12" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "WalletConnect",
  setup(__props) {
    const { it } = useTranslation();
    onErrorCaptured((e) => {
      console.error("DApps: onErrorCaptured", e);
      return true;
    });
    const entry = ref(null);
    const tabIndex = ref(0);
    const optionsTabs = reactive([
      { id: "connect", label: it("walletconnect.tabs.connect"), index: 0, hidden: false },
      { id: "manage", label: it("walletconnect.tabs.manage"), index: 1, hidden: false }
    ]);
    ref(false);
    function onTabChanged(index) {
      entry.value = null;
      if (tabIndex.value !== index) {
        tabIndex.value = index;
      }
    }
    const editEntry = (event) => {
      onTabChanged(0);
      entry.value = event.entry;
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("main", _hoisted_2, [
          createVNode(_sfc_main$f, {
            containerCSS: "",
            "align-top": "",
            "add-scroll": true
          }, {
            default: withCtx(() => [
              createBaseVNode("div", _hoisted_3, [
                createVNode(_sfc_main$e, {
                  tabs: optionsTabs,
                  index: tabIndex.value,
                  onSelection: onTabChanged
                }, {
                  tab0: withCtx(() => [
                    createVNode(_sfc_main$3, { entry: entry.value }, null, 8, ["entry"])
                  ]),
                  tab1: withCtx(() => [
                    createVNode(_sfc_main$1, { onEdit: editEntry })
                  ]),
                  _: 1
                }, 8, ["tabs", "index"])
              ])
            ]),
            _: 1
          })
        ])
      ]);
    };
  }
});
export {
  _sfc_main as default
};
