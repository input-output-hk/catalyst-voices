import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$f } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$e } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, de as useCardanoConnect, K as networkId, z as ref, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, u as unref, i as createTextVNode, n as normalizeClass, j as createCommentVNode, a as createBlock, B as useFormatter, be as useWalletAccount, S as reactive, w as watchEffect, aG as onUnmounted, q as createVNode, H as Fragment, I as renderList, df as useUiSelectedAccount, d9 as getWalletNameList, a7 as useQuasar, D as watch, dg as savePeerInfo, C as onMounted, h as withCtx, dh as walletsExists, di as EternlPeerConnect, f as computed, b as withModifiers, V as nextTick, dj as cardanoConnectDBList, bI as onBeforeMount, aH as QPagination_default, dk as updateCardanoConnectList, ct as onErrorCaptured } from "./index.js";
import { u as useDappAccount } from "./useDappAccount.js";
import { _ as _sfc_main$8, a as _sfc_main$9 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { G as GridInput } from "./GridInput.js";
import { I as IconPencil } from "./IconPencil.js";
import { _ as _sfc_main$c } from "./ScanQrCode2.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$7 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$a } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$b } from "./DAppsAccountItem.vue_vue_type_script_setup_true_lang.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { _ as _sfc_main$d } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./useTabId.js";
import "./NetworkId.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./IconError.js";
import "./Modal.js";
import "./QrcodeStream.js";
import "./scanner.js";
import "./AccountItemBalance.vue_vue_type_script_setup_true_lang.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1$5 = { class: "relative w-full flex flex-col flex-nowrap justify-between items-start pt-0.5 top-3.5 pb-3" };
const _hoisted_2$5 = { class: "grid grid-cols-12 w-full" };
const _hoisted_3$5 = { class: "col-span-6 cc-area-light-1 p-2 m-1" };
const _hoisted_4$4 = { class: "col-span-4 text-xs pr-2" };
const _hoisted_5$2 = { class: "col-span-8 cc-text-bold justify-start" };
const _hoisted_6$2 = { class: "col-span-6 cc-area-light-1 py-2 my-1 pl-2 ml-1" };
const _hoisted_7$2 = { class: "w-full text-xs pr-2" };
const _hoisted_8$2 = { class: "w-full cc-text-bold justify-start" };
const _hoisted_9$1 = { class: "w-full cc-text-bold text-xs justify-start" };
const _hoisted_10$1 = ["href"];
const _hoisted_11 = { class: "grid grid-cols-12 w-full" };
const _hoisted_12 = { class: "col-span-6 cc-area-light-1 p-2 m-1" };
const _hoisted_13 = { class: "col-span-12 text-xs" };
const _hoisted_14 = { class: "col-span-12 cc-text-bold justify-start" };
const _hoisted_15 = { class: "col-span-6 cc-area-light-1 py-2 my-1 pl-2 ml-1" };
const _hoisted_16 = { class: "col-span-12 text-xs" };
const _hoisted_17 = { class: "col-span-12 cc-text-bold justify-start" };
const _hoisted_18 = { class: "grid grid-cols-12 w-full" };
const _hoisted_19 = { class: "col-span-6 cc-area-light-1 p-2 m-1" };
const _hoisted_20 = { class: "w-full grid grid-cols-12" };
const _hoisted_21 = { class: "col-span-6" };
const _hoisted_22 = { class: "w-full" };
const _hoisted_23 = { class: "w-full text-xs pr-2" };
const _hoisted_24 = { class: "w-full text-bold" };
const _hoisted_25 = { class: "w-full mt-2 text-xs" };
const _hoisted_26 = { class: "w-full text-xs pr-2" };
const _hoisted_27 = { class: "w-full text-bold" };
const _hoisted_28 = { class: "col-span-6 flex justify-center items-center" };
const _hoisted_29 = { class: "flex flex-col items-center" };
const _hoisted_30 = {
  class: "text-xs pr-2 flex-shrink-0",
  id: "A1"
};
const _hoisted_31 = {
  class: "cc-text-bold flex-grow",
  id: "A2"
};
const _hoisted_32 = ["src"];
const _hoisted_33 = { class: "col-span-6 cc-area-light-1 py-2 my-1 pl-2 ml-1" };
const _hoisted_34 = { class: "w-full" };
const _hoisted_35 = { class: "w-full text-xs pr-2" };
const _hoisted_36 = { class: "w-full py-2 my-1" };
const _hoisted_37 = { class: "w-full grid grid-cols-12" };
const _hoisted_38 = { class: "col-span-4 cc-text-bold pr-2" };
const _hoisted_39 = {
  key: 0,
  class: "mdi mdi-check-bold cc-text-green"
};
const _hoisted_40 = {
  key: 1,
  class: "mdi mdi-checkbox-blank-outline cc-text-red"
};
const _hoisted_41 = { class: "w-full py-2 my-1" };
const _hoisted_42 = { class: "w-full col-span-12 grid grid-cols-12" };
const _hoisted_43 = { class: "col-span-4 cc-text-bold pr-2" };
const _hoisted_44 = { class: "col-span-8 justify-start" };
const _hoisted_45 = { class: "w-full col-span-12 grid grid-cols-12" };
const _hoisted_46 = { class: "col-span-4 cc-text-bold pr-2" };
const _hoisted_47 = { class: "col-span-8 justify-start" };
const _hoisted_48 = { class: "w-full col-span-12 grid grid-cols-12 justify-end" };
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "GridPeerDetails",
  props: {
    peerInfo: { type: Object, required: true },
    showEdit: { type: Boolean, required: false, default: true },
    showDelete: { type: Boolean, required: false, default: true },
    showDisconnect: { type: Boolean, required: false, default: true }
  },
  emits: ["delete", "edit", "togglePeerConnection", "toggleAutoConnect"],
  setup(__props, { emit: __emit }) {
    var _a;
    const props = __props;
    const emit = __emit;
    const { it, c } = useTranslation();
    const {
      getDAppConnectionIdenticon
    } = useCardanoConnect(ref((_a = props.peerInfo) == null ? void 0 : _a.peerDappInfo.address), networkId.value);
    const identicon = ref(getDAppConnectionIdenticon());
    let {
      walletName,
      accountName
    } = useCardanoConnect(ref(props.peerInfo.peerDappInfo.address), networkId.value);
    const {
      formatDatetime
    } = useFormatter();
    const toggleConnection = (event) => {
      event.preventDefault();
      event.stopPropagation();
      console.log("clicked toggleConnection in detail view, emit");
      emit("togglePeerConnection");
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$5, [
        createBaseVNode("div", _hoisted_2$5, [
          createBaseVNode("div", _hoisted_3$5, [
            createBaseVNode("div", _hoisted_4$4, toDisplayString(unref(it)("directconnect.connect.label.status")), 1),
            createBaseVNode("div", _hoisted_5$2, toDisplayString(__props.peerInfo.active ? unref(it)("directconnect.connect.status.connected") : unref(it)("directconnect.connect.status.disconnected")), 1)
          ]),
          createBaseVNode("div", _hoisted_6$2, [
            createBaseVNode("div", _hoisted_7$2, toDisplayString(unref(it)("directconnect.connect.labels.connectedTo")), 1),
            createBaseVNode("div", _hoisted_8$2, toDisplayString(__props.peerInfo.peerDappInfo.name), 1),
            createBaseVNode("div", _hoisted_9$1, [
              createBaseVNode("a", {
                href: __props.peerInfo.peerDappInfo.url,
                target: "_blank",
                rel: "noopener noreferrer",
                class: "flex flex-nowrap items-start justify-start flex-row"
              }, [
                createTextVNode(toDisplayString(__props.peerInfo.peerDappInfo.url) + " ", 1),
                _cache[1] || (_cache[1] = createBaseVNode("i", { class: "mdi mdi-open-in-new ml-1" }, null, -1))
              ], 8, _hoisted_10$1)
            ])
          ])
        ]),
        createBaseVNode("div", _hoisted_11, [
          createBaseVNode("div", _hoisted_12, [
            createBaseVNode("div", _hoisted_13, toDisplayString(unref(it)("directconnect.connect.labels.walletConnectionId")), 1),
            createBaseVNode("div", _hoisted_14, toDisplayString(__props.peerInfo.walletConnectionId), 1)
          ]),
          createBaseVNode("div", _hoisted_15, [
            createBaseVNode("div", _hoisted_16, toDisplayString(unref(it)("directconnect.connect.labels.address")), 1),
            createBaseVNode("div", _hoisted_17, toDisplayString(__props.peerInfo.peerDappInfo.address), 1)
          ])
        ]),
        createBaseVNode("div", _hoisted_18, [
          createBaseVNode("div", _hoisted_19, [
            createBaseVNode("div", _hoisted_20, [
              createBaseVNode("div", _hoisted_21, [
                createBaseVNode("div", _hoisted_22, [
                  createBaseVNode("div", _hoisted_23, toDisplayString(unref(it)("directconnect.connect.labels.walletId")), 1)
                ]),
                createBaseVNode("div", _hoisted_24, toDisplayString(unref(walletName)), 1),
                createBaseVNode("div", _hoisted_25, [
                  createBaseVNode("div", _hoisted_26, toDisplayString(unref(it)("directconnect.connect.labels.accountPubKey")), 1)
                ]),
                createBaseVNode("div", _hoisted_27, toDisplayString(unref(accountName)), 1)
              ]),
              createBaseVNode("div", _hoisted_28, [
                createBaseVNode("div", _hoisted_29, [
                  createBaseVNode("div", _hoisted_30, toDisplayString(unref(it)("directconnect.connect.identicon.image")), 1),
                  createBaseVNode("div", _hoisted_31, [
                    identicon.value ? (openBlock(), createElementBlock("img", {
                      key: 0,
                      class: normalizeClass(__props.peerInfo.active ? "" : "grayscale"),
                      style: { "width": "100px", "height": "100px" },
                      src: identicon.value
                    }, null, 10, _hoisted_32)) : createCommentVNode("", true)
                  ])
                ])
              ])
            ])
          ]),
          createBaseVNode("div", _hoisted_33, [
            createBaseVNode("div", _hoisted_34, [
              createBaseVNode("div", _hoisted_35, toDisplayString(unref(it)("directconnect.connect.labels.info")), 1)
            ]),
            createBaseVNode("div", _hoisted_36, [
              createBaseVNode("div", _hoisted_37, [
                createBaseVNode("div", _hoisted_38, toDisplayString(unref(it)("directconnect.connect.labels.autoConnect")), 1),
                createBaseVNode("div", {
                  class: "col-span-8 justify-start cursor-pointer",
                  onClick: _cache[0] || (_cache[0] = ($event) => emit("toggleAutoConnect"))
                }, [
                  __props.peerInfo.autoConnect ? (openBlock(), createElementBlock("i", _hoisted_39)) : createCommentVNode("", true),
                  !__props.peerInfo.autoConnect ? (openBlock(), createElementBlock("i", _hoisted_40)) : createCommentVNode("", true)
                ])
              ])
            ]),
            createBaseVNode("div", _hoisted_41, [
              createBaseVNode("div", _hoisted_42, [
                createBaseVNode("div", _hoisted_43, toDisplayString(unref(it)("directconnect.connect.labels.lastActive")), 1),
                createBaseVNode("div", _hoisted_44, toDisplayString(unref(formatDatetime)(__props.peerInfo.lastActive ?? 0)), 1)
              ]),
              createBaseVNode("div", _hoisted_45, [
                createBaseVNode("div", _hoisted_46, toDisplayString(unref(it)("directconnect.connect.labels.created")), 1),
                createBaseVNode("div", _hoisted_47, toDisplayString(unref(formatDatetime)(__props.peerInfo.created)), 1)
              ])
            ])
          ])
        ]),
        createBaseVNode("div", _hoisted_48, [
          __props.showDisconnect ? (openBlock(), createBlock(_sfc_main$7, {
            key: 0,
            label: __props.peerInfo.active ? unref(it)("directconnect.connect.label.disconnect") : unref(it)("directconnect.connect.label.connect"),
            onClick: toggleConnection,
            class: "col-start-0 col-span-12 md:col-start-0 md:col-span-3 m-2"
          }, null, 8, ["label"])) : createCommentVNode("", true),
          __props.showEdit ? (openBlock(), createBlock(_sfc_main$7, {
            key: 1,
            label: unref(it)("directconnect.connect.actions.edit"),
            link: () => emit("edit"),
            class: "col-start-0 col-span-12 md:col-start-7 md:col-span-3 m-2"
          }, null, 8, ["label", "link"])) : createCommentVNode("", true),
          __props.showDelete ? (openBlock(), createBlock(_sfc_main$7, {
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
const _hoisted_1$4 = { class: "cc-grid cc-text-sz" };
const _hoisted_2$4 = {
  key: 0,
  class: "cc-grid"
};
const _hoisted_3$4 = { class: "col-span-12 grid grid-cols-12 cc-gap mb-2" };
const _hoisted_4$3 = ["selected", "value"];
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "DAppsPeerConnectAccountList",
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
      setUiSelectedWalletId(walletId, uiSelectedWalletId.value === walletId);
    };
    const onActivateAccount = (payload) => {
      if (payload.walletId && payload.accountId) {
        doSelectWallet(payload.walletId);
        setUiSelectedWalletId(payload.walletId);
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
      return openBlock(), createElementBlock("div", _hoisted_1$4, [
        createVNode(_sfc_main$8, {
          label: unref(it)("dapps.accountSelection.headline")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$9, {
          text: unref(it)("dapps.accountSelection.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12"
        }),
        walletNameList.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_2$4, [
          createBaseVNode("div", _hoisted_3$4, [
            createVNode(_sfc_main$8, {
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
                }, toDisplayString(data.name + (data.id === unref(dappWalletId) ? " (" + unref(it)("dapps.accountSelection.selectedWallet") + ")" : "")), 9, _hoisted_4$3);
              }), 128))
            ], 32)
          ])
        ])) : createCommentVNode("", true),
        unref(appWallet) && unref(appWallet).isReadOnly ? (openBlock(), createBlock(_sfc_main$a, {
          key: 1,
          icon: unref(it)("wallet.summary.setDAppAccount.warning.readOnly.icon"),
          text: unref(it)("wallet.summary.setDAppAccount.warning.readOnly.text"),
          class: "col-span-12",
          "text-c-s-s": "text-justify flex justify-start items-center",
          css: "cc-rounded cc-banner-warning"
        }, null, 8, ["icon", "text"])) : createCommentVNode("", true),
        createVNode(GridSpace, { hr: "" }),
        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(accountList), (account) => {
          return openBlock(), createBlock(_sfc_main$b, {
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
const _sfc_main$4 = {};
function _sfc_render(_ctx, _cache) {
  return null;
}
const DAppConnectItem = /* @__PURE__ */ _export_sfc(_sfc_main$4, [["render", _sfc_render]]);
const _hoisted_1$3 = { class: "cc-grid" };
const _hoisted_2$3 = { class: "relative w-full grid grid-cols-12 gap-2 col-span-12" };
const _hoisted_3$3 = { class: "col-span-10 md:col-span-11" };
const _hoisted_4$2 = { class: "col-span-2 md:col-span-1" };
const _hoisted_5$1 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12"
};
const _hoisted_6$1 = {
  key: 1,
  class: "col-span-12 grid grid-cols-12"
};
const _hoisted_7$1 = {
  key: 2,
  class: "col-span-12"
};
const _hoisted_8$1 = {
  key: 3,
  class: "col-span-12"
};
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "DAppsPeerConnect",
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
    const peerConnect = ref(null);
    const identicon = ref(null);
    const peerAccountList = ref(null);
    const log = (...entries) => {
    };
    const $q = useQuasar();
    const dAppIdentifier = ref(((_a = props.entry) == null ? void 0 : _a.peerDappInfo.address) ?? "");
    const inputError = ref("");
    let currentDBInfo = ref(null);
    const connectStatus = ref();
    const inEdit = ref(false);
    const isValidConnectId = ref(false);
    const checkInput = async (dappId, loadFromDb = false) => {
      var _a2, _b, _c;
      dAppIdentifier.value = dappId;
      if (!EternlPeerConnect.isBase58EncodedString(dappId)) {
        isValidConnectId.value = false;
        inputError.value = it("directconnect.connect.status.invalidAddress");
      }
      if (loadFromDb) {
        const { dbInfo } = useCardanoConnect(ref(dappId), networkId.value);
        if (dbInfo.value) {
          inputError.value = "";
          isValidConnectId.value = true;
          setUiSelectedWalletId((_a2 = dbInfo.value) == null ? void 0 : _a2.walletId);
          setUiSelectedAccountId((_b = dbInfo.value) == null ? void 0 : _b.accountId);
          (_c = peerAccountList.value) == null ? void 0 : _c.onActivateAccount({
            walletId: uiSelectedWalletId.value,
            accountId: uiSelectedAccountId.value,
            skipEmit: true
          });
          const { initConnection } = useCardanoConnect(ref(dappId), networkId.value);
          initConnection();
          return;
        } else {
          console.log("no peer connect info found");
        }
      }
      if (!walletsExists.value) {
        inputError.value = it("directconnect.connect.status.nowallets");
        return;
      } else if (!uiSelectedWalletId.value || !uiSelectedAccountId.value) {
        inputError.value = it("directconnect.connect.status.noaccount");
        return;
      }
      inputError.value = "";
      isValidConnectId.value = true;
    };
    watch(uiSelectedAccountId, () => {
      checkInput(dAppIdentifier.value, false);
      if (inEdit && (currentDBInfo.value && currentDBInfo.value.accountId !== uiSelectedAccountId.value)) {
        saveChanges();
      }
    });
    const showConnectionInfo = () => {
      var _a2, _b, _c, _d, _e, _f;
      if (currentDBInfo.value) {
        setUiSelectedWalletId((_a2 = currentDBInfo.value) == null ? void 0 : _a2.walletId);
        setUiSelectedAccountId((_b = currentDBInfo.value) == null ? void 0 : _b.accountId);
        connectStatus.value = {
          dApp: currentDBInfo.value.peerDappInfo,
          address: currentDBInfo.value.walletConnectionId,
          connected: currentDBInfo.value.active,
          autoConnect: currentDBInfo.value.autoConnect,
          error: false
        };
        if ((_d = (_c = currentDBInfo.value) == null ? void 0 : _c.peerDappInfo) == null ? void 0 : _d.address) {
          const cardanoConnect = useCardanoConnect(ref((_f = (_e = currentDBInfo.value) == null ? void 0 : _e.peerDappInfo) == null ? void 0 : _f.address), networkId.value);
          const { getDAppConnectionIdenticon } = cardanoConnect;
          identicon.value = getDAppConnectionIdenticon();
        }
        inEdit.value = true;
      } else {
        connectStatus.value = null;
        inEdit.value = false;
        identicon.value = null;
      }
    };
    watch(() => currentDBInfo.value, () => {
      showConnectionInfo();
    }, { deep: true });
    watch(() => dAppIdentifier.value, () => {
      showConnectionInfo();
    });
    showConnectionInfo();
    const reloadDBEntry = (connected, activeDbInfo) => {
      if (connected) {
        currentDBInfo.value = activeDbInfo;
      }
    };
    const connect = async (id = dAppIdentifier.value) => {
      const cardanoConnect = useCardanoConnect(ref(id), networkId.value);
      const {
        initConnection,
        connect: connect2,
        connectAppWallet,
        connectAppAccount,
        setOnConnectFunction
      } = cardanoConnect;
      setOnConnectFunction(reloadDBEntry);
      if ((!connectAppWallet.value || !connectAppAccount.value) && (uiSelectedWalletId.value && uiSelectedAccountId.value)) {
        const {
          appWallet,
          appAccount
        } = useWalletAccount(uiSelectedWalletId, uiSelectedWalletId);
        connectAppWallet.value = appWallet.value;
        connectAppAccount.value = appAccount.value;
      }
      initConnection();
      await connect2();
    };
    const toggleAutoConnect = async () => {
      if (!currentDBInfo.value) {
        return;
      }
      const {
        saveAutoConnectStatus
      } = useCardanoConnect(ref(currentDBInfo.value.peerDappInfo.address), networkId.value);
      await saveAutoConnectStatus(!currentDBInfo.value.autoConnect);
    };
    const disconnect = () => {
      var _a2;
      log("disconnect", currentDBInfo.value, dAppIdentifier.value);
      if (!currentDBInfo.value) {
        log("peer connect not found in disconnect", peerConnect.value);
        return;
      }
      try {
        const cardanoConnect = useCardanoConnect(ref((_a2 = currentDBInfo.value) == null ? void 0 : _a2.peerDappInfo.address), networkId.value);
        const { disconnect: disconnect2 } = cardanoConnect;
        disconnect2();
        identicon.value = null;
      } catch (e) {
        if (e.message.includes("Meerkat not connected") || e.message.includes("not seen - no public key")) ;
        else {
          console.error("Error on disconnect:", e);
        }
      }
    };
    const onQrCode = (payload) => {
      let code = payload.content;
      if (code.includes(":")) {
        code = code.split(":")[0];
      }
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
      checkInput(clipboardData, true);
    };
    const saveChanges = async () => {
      if (!uiSelectedWalletId.value || !uiSelectedAccountId.value) {
        return;
      }
      if (!dAppIdentifier.value) {
        return;
      }
      const {
        dbInfo,
        connectAppAccount,
        connectAppWallet
      } = useCardanoConnect(ref(dAppIdentifier.value), networkId.value);
      if (dbInfo.value) {
        dbInfo.value.walletId = uiSelectedWalletId.value;
        dbInfo.value.accountId = uiSelectedAccountId.value;
        await savePeerInfo(dbInfo.value);
        if (!uiSelectedWalletId.value || !uiSelectedAccountId.value) {
          return;
        }
        if (!connectAppWallet.value || !connectAppAccount.value) {
          return;
        }
        const cardanoConnect = useCardanoConnect(ref(dbInfo.value.peerDappInfo.address), networkId.value);
        const { initConnection, injectNewApi } = cardanoConnect;
        initConnection();
        injectNewApi(connectAppWallet.value, connectAppAccount.value);
        if (dbInfo.value.active) {
          window.addEventListener("peer-connection-injected-" + dAppIdentifier.value, (event) => {
            const message = event.detail.message;
            if (message) {
              $q.notify({
                type: "positive",
                message: "Changes were saved, new account was injected into DApp.",
                position: "top-left",
                timeout: 2e3
              });
            }
          });
        } else {
          $q.notify({
            type: "positive",
            message: "Changes were saved.",
            position: "top-left",
            timeout: 2e3
          });
        }
      }
    };
    onMounted(() => {
      var _a2, _b, _c;
      if ((_a2 = props.entry) == null ? void 0 : _a2.peerDappInfo.address) {
        console.log("in edit for", (_b = props.entry) == null ? void 0 : _b.peerDappInfo.address);
        const { dbInfo } = useCardanoConnect(ref(props.entry ? (_c = props.entry) == null ? void 0 : _c.peerDappInfo.address : dAppIdentifier.value), networkId.value);
        currentDBInfo = dbInfo;
        inEdit.value = true;
        if (currentDBInfo.value) {
          setUiSelectedWalletId(currentDBInfo.value.walletId);
          setUiSelectedAccountId(currentDBInfo.value.accountId);
        }
      }
    });
    return (_ctx, _cache) => {
      var _a2, _b, _c;
      return openBlock(), createElementBlock("div", _hoisted_1$3, [
        unref(currentDBInfo) && ((_a2 = connectStatus.value) == null ? void 0 : _a2.connected) ? (openBlock(), createBlock(DAppConnectItem, {
          key: 0,
          dapp: unref(currentDBInfo)
        }, null, 8, ["dapp"])) : createCommentVNode("", true),
        createVNode(_sfc_main$8, {
          label: unref(it)("directconnect.connect.headline"),
          "do-capitalize": false
        }, null, 8, ["label"]),
        createVNode(_sfc_main$9, {
          text: unref(it)("directconnect.connect.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, { hr: "" }),
        createBaseVNode("div", _hoisted_2$3, [
          createBaseVNode("div", _hoisted_3$3, [
            createVNode(GridInput, {
              "input-text": dAppIdentifier.value,
              "onUpdate:inputText": [
                _cache[0] || (_cache[0] = ($event) => dAppIdentifier.value = $event),
                checkInput
              ],
              onEnter: connect,
              onReset: reset,
              onPaste,
              "input-disabled": inEdit.value,
              "input-hint": unref(it)("directconnect.connect.identifier.hint"),
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
          createBaseVNode("div", _hoisted_4$2, [
            createVNode(_sfc_main$c, {
              onDecode: onQrCode,
              class: "relative w-full h-full flex flex-row flex-nowrap justify-center items-center cursor-pointer focus:outline-none text-sm cc-text-bold cc-btn-secondary"
            })
          ]),
          !((_b = connectStatus.value) == null ? void 0 : _b.connected) && !inEdit.value ? (openBlock(), createElementBlock("div", _hoisted_5$1, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("common.label.connectDApp"),
              link: connect,
              type: "button",
              disabled: !isValidConnectId.value,
              class: "col-start-9 col-span-4"
            }, null, 8, ["label", "disabled"])
          ])) : createCommentVNode("", true),
          ((_c = connectStatus.value) == null ? void 0 : _c.connected) && !inEdit.value ? (openBlock(), createElementBlock("div", _hoisted_6$1, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("common.label.disconnect"),
              link: disconnect,
              type: "button",
              class: "col-start-9 col-span-4"
            }, null, 8, ["label"])
          ])) : createCommentVNode("", true),
          unref(currentDBInfo) ? (openBlock(), createElementBlock("div", _hoisted_7$1, [
            createVNode(_sfc_main$6, {
              "peer-info": unref(currentDBInfo),
              "show-edit": false,
              "show-delete": false,
              "show-disconnect": false,
              onToggleAutoConnect: toggleAutoConnect
            }, null, 8, ["peer-info"])
          ])) : createCommentVNode("", true),
          unref(walletsExists) ? (openBlock(), createElementBlock("div", _hoisted_8$1, [
            createVNode(_sfc_main$5, {
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
const _hoisted_5 = { key: 0 };
const _hoisted_6 = { class: "cc-none inline-flex justify-center cc-badge-blue" };
const _hoisted_7 = { class: "ml-6 mt-1 cc-addr break-normal" };
const _hoisted_8 = { class: "relative col items-center w-full max-w-full" };
const _hoisted_9 = {
  key: 0,
  class: "w-10 h-10 flex flex-row flex-nowrap justify-end items-center"
};
const _hoisted_10 = {
  key: 1,
  class: "w-10 h-10 flex flex-row flex-nowrap justify-end items-center"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GridPeerConnectListEntry",
  props: {
    entry: { type: Object, required: true }
  },
  emits: ["delete", "edit"],
  setup(__props, { emit: __emit }) {
    var _a;
    const emit = __emit;
    const props = __props;
    console.log("prop is", props.entry);
    const { it, c } = useTranslation();
    const open = ref(false);
    useQuasar();
    const log = (...entries) => {
    };
    const {
      dbInfo,
      saveAutoConnectStatus,
      deleteConnection,
      disconnect,
      reconnect
    } = useCardanoConnect(ref(props.entry.peerDappInfo.address), networkId.value);
    const quasar = useQuasar();
    const toggleAutoConnect = async () => {
      var _a2;
      if (!((_a2 = props.entry) == null ? void 0 : _a2.peerDappInfo.address)) {
        return;
      }
      await saveAutoConnectStatus(!props.entry.autoConnect);
    };
    const {
      walletData,
      accountData
    } = useWalletAccount(ref(props.entry.walletId), ref((_a = props.entry) == null ? void 0 : _a.accountId));
    computed(() => {
      var _a2;
      return ((_a2 = walletData.value) == null ? void 0 : _a2.settings.name) ?? "Unknown wallet name.";
    });
    computed(() => {
      var _a2;
      return ((_a2 = accountData.value) == null ? void 0 : _a2.settings.name) ?? "Unknown account name";
    });
    const deleteEntry = async () => {
      if (!networkId.value || !props.entry) return;
      await deleteConnection();
      nextTick(() => {
        emit("delete");
      });
    };
    const editEntry = async () => {
      if (!networkId.value) return;
      emit("edit", { entry: props.entry });
    };
    const toggleConnection = (event) => {
      log("toggle connection coming from detail in list view", dbInfo.value);
      if (event instanceof Event) {
        event.preventDefault();
        event.stopPropagation();
      }
      if (dbInfo.value && dbInfo.value.active) {
        try {
          disconnect();
        } catch (e) {
          if (e.message && e.message.includes("not seen - no public key")) {
            quasar.notify({
              type: "warning",
              message: "Connection endpoint is not available. Reload the DApp window and try again.",
              position: "top-left"
            });
          }
        }
      } else {
        reconnect();
      }
    };
    return (_ctx, _cache) => {
      var _a2, _b, _c, _d, _e, _f, _g;
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
                  createBaseVNode("div", _hoisted_4$1, toDisplayString((_a2 = unref(dbInfo)) == null ? void 0 : _a2.peerDappInfo.name), 1),
                  createBaseVNode("div", null, [
                    createBaseVNode("div", {
                      class: normalizeClass(["cc-none inline-flex justify-center", ((_b = unref(dbInfo)) == null ? void 0 : _b.active) ? "cc-badge-green" : "cc-badge-yellow"])
                    }, [
                      createTextVNode(toDisplayString(((_c = unref(dbInfo)) == null ? void 0 : _c.active) ? unref(it)("directconnect.connect.status.connected") : unref(it)("directconnect.connect.status.disconnected")) + " ", 1),
                      createVNode(_sfc_main$d, {
                        anchor: "center right",
                        self: "center left",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => {
                          var _a3;
                          return [
                            createTextVNode(toDisplayString(((_a3 = unref(dbInfo)) == null ? void 0 : _a3.active) ? unref(it)("directconnect.connect.badge.connected") : unref(it)("directconnect.connect.badge.disconnected")), 1)
                          ];
                        }),
                        _: 1
                      })
                    ], 2)
                  ]),
                  ((_d = unref(dbInfo)) == null ? void 0 : _d.autoConnect) ? (openBlock(), createElementBlock("div", _hoisted_5, [
                    createBaseVNode("div", _hoisted_6, [
                      createTextVNode(toDisplayString(unref(it)("directconnect.connect.autoconnect")) + " ", 1),
                      createVNode(_sfc_main$d, {
                        anchor: "center right",
                        self: "center left",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(it)("directconnect.connect.badge.autoconnect")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])) : createCommentVNode("", true)
                ], 2)
              ]),
              createBaseVNode("div", _hoisted_7, toDisplayString((_e = unref(dbInfo)) == null ? void 0 : _e.peerDappInfo.url), 1)
            ]),
            createBaseVNode("div", {
              class: "inline-flex items-top self-start justify-center pt-1 relative",
              onClick: toggleConnection
            }, [
              createBaseVNode("div", _hoisted_8, [
                ((_f = unref(dbInfo)) == null ? void 0 : _f.active) ? (openBlock(), createElementBlock("div", _hoisted_9, [
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
                !((_g = unref(dbInfo)) == null ? void 0 : _g.active) ? (openBlock(), createElementBlock("div", _hoisted_10, [
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
          open.value && unref(dbInfo) ? (openBlock(), createBlock(_sfc_main$6, {
            key: 0,
            "peer-info": unref(dbInfo),
            onTogglePeerConnection: toggleConnection,
            onToggleAutoConnect: toggleAutoConnect,
            onEdit: editEntry,
            onDelete: deleteEntry
          }, null, 8, ["peer-info"])) : createCommentVNode("", true)
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
const itemsOnPage = 3;
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "DAppsPeerManager",
  emits: ["edit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    useTranslation();
    const currentPage = ref(1);
    const showPagination = computed(() => cardanoConnectDBList.length > itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const maxPages = computed(() => Math.ceil(cardanoConnectDBList.length / itemsOnPage));
    const reloadEntries = async () => {
      if (!networkId.value) {
        return;
      }
      await updateCardanoConnectList(true);
    };
    const pagedPeerConnections = computed(() => {
      return cardanoConnectDBList.slice(currentPageStart.value, currentPageStart.value + itemsOnPage);
    });
    const editEntry = (event) => {
      emit("edit", event);
    };
    onBeforeMount(async () => {
      await reloadEntries();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createBaseVNode("div", _hoisted_2$1, [
          (openBlock(true), createElementBlock(Fragment, null, renderList(pagedPeerConnections.value, (item) => {
            return openBlock(), createBlock(_sfc_main$2, {
              key: item.peerDappInfo.address,
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
  __name: "CardanoConnect",
  setup(__props) {
    const { it } = useTranslation();
    onErrorCaptured((e) => {
      console.error("DApps: onErrorCaptured", e);
      return true;
    });
    const entry = ref(null);
    const tabIndex = ref(0);
    const optionsTabs = reactive([
      { id: "connect", label: it("directconnect.tabs.connect"), index: 0, hidden: false },
      { id: "manage", label: it("directconnect.tabs.manage"), index: 1, hidden: false }
    ]);
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
