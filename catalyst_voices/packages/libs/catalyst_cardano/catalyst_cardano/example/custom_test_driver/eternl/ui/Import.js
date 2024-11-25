import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$8 } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { ec as isSupportedSignType, ed as hasWallet, ee as createIRootKey, ef as createIWallet, eg as createIAccountSettings, eh as createIAccount, ei as putLegacyNotes, ej as createIWalletSettings, ek as addWallet, el as createIAddressBook, em as mergeAddressBook, a_ as decryptText, bv as getAppInfo, d as defineComponent, o as openBlock, a as createBlock, u as unref, j as createCommentVNode, a7 as useQuasar, z as ref, C as onMounted, c as createElementBlock, q as createVNode, e as createBaseVNode, K as networkId, en as addLegacySettings, eo as sleepDefault, h as withCtx, t as toDisplayString } from "./index.js";
import { c as isSupportedNetworkId } from "./NetworkId.js";
import { _ as _sfc_main$5, a as _sfc_main$6 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$7 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$4 } from "./AccessPasswordInputModal.vue_vue_type_script_setup_true_lang.js";
import { u as useNavigation } from "./useNavigation.js";
import "./_plugin-vue_export-helper.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./Modal.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonSecondary.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import "./GridInput.js";
import "./IconError.js";
import "./useTabId.js";
const createIWalletDBEntry = (wallet, name, groupName = "My Wallets", deviceId) => {
  return {
    network: wallet.network,
    signType: wallet.signType,
    version: wallet.version,
    id: wallet.id,
    deviceId,
    name,
    groupName,
    encryptedWallet: null,
    data: {
      plate: {
        image: null,
        text: "",
        data: null
      },
      background: {
        policy: null,
        name: null,
        opacity: null
      }
    }
  };
};
const updateIWalletDBEntry = (dbEntry, entry) => {
  var _a, _b, _c, _d;
  if (dbEntry.id === entry.id) {
    dbEntry.name = entry.name;
    dbEntry.groupName = entry.groupName ?? "My Wallets";
    dbEntry.version = entry.version;
    dbEntry.encryptedWallet = entry.encryptedWallet;
    if ((_b = (_a = entry.data) == null ? void 0 : _a.plate) == null ? void 0 : _b.image) {
      dbEntry.data = {
        plate: {
          image: entry.data.plate.image,
          text: entry.data.plate.text,
          data: entry.data.plate.data
        },
        background: {
          policy: entry.data.background ? entry.data.background.policy : "",
          name: entry.data.background ? entry.data.background.name : "",
          opacity: entry.data.background ? entry.data.background.opacity : ""
        }
      };
    } else if ((((_d = (_c = dbEntry.data) == null ? void 0 : _c.plate) == null ? void 0 : _d.image) ?? null) === null) {
      dbEntry.data = {
        plate: {
          image: "",
          text: "",
          data: ""
        },
        background: {
          policy: "",
          name: "",
          opacity: ""
        }
      };
    }
  } else {
    console.error("Error: updateIWalletDBEntry: ids don't match: ", dbEntry, entry);
    throw new Error("Error: updateIWalletDBEntry: ids don't match.");
  }
};
const isValidIWalletDBEntry = (dbEntry) => {
  if (!dbEntry.hasOwnProperty("network")) {
    throw new Error("Error: unknown wallet format: network missing.");
  }
  if (!dbEntry.hasOwnProperty("signType")) {
    throw new Error("Error: unknown wallet format: signType missing.");
  }
  if (!dbEntry.hasOwnProperty("version")) {
    throw new Error("Error: unknown wallet format: version missing.");
  }
  if (!dbEntry.hasOwnProperty("name")) {
    throw new Error("Error: unknown wallet format: name missing.");
  }
  if (!dbEntry.hasOwnProperty("id")) {
    throw new Error("Error: unknown wallet format: id missing.");
  }
  if (!dbEntry.hasOwnProperty("encryptedWallet")) {
    throw new Error("Error: unknown wallet format: encryptedWallet missing.");
  }
  if (!isSupportedNetworkId(dbEntry.network)) {
    throw new Error("Error: unknown network: " + dbEntry.network);
  }
  if (!isSupportedSignType(dbEntry.signType)) {
    throw new Error("Error: unknown signType: " + dbEntry.signType);
  }
  if (!dbEntry.encryptedWallet) {
    throw new Error("Error: no encryptedWallet");
  }
  return true;
};
const addToCoreV2 = async (dbEntry, wallet, mode = "v1") => {
  var _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, _n, _o, _p, _q, _r, _s, _t;
  if (!hasWallet(dbEntry.id)) {
    let rootKey = null;
    const oldRootKey = wallet.root ?? null;
    if (oldRootKey) {
      rootKey = createIRootKey(oldRootKey.pub, oldRootKey.prv);
    }
    const tmpWalletV2 = createIWallet({
      id: dbEntry.id,
      networkId: dbEntry.network,
      rootKey,
      signType: dbEntry.signType,
      accountList: []
    });
    const migratedAccountSettingsList = [];
    const migratedAccountSettings = createIAccountSettings(tmpWalletV2.id, tmpWalletV2.networkId, dbEntry);
    migratedAccountSettings.sam.enabled = ((_b = (_a = wallet.settings) == null ? void 0 : _a.changeAddress) == null ? void 0 : _b.enabled) ?? true;
    migratedAccountSettings.sam.addr = migratedAccountSettings.sam.enabled ? ((_e = (_d = (_c = wallet.settings) == null ? void 0 : _c.changeAddr) == null ? void 0 : _d.value) == null ? void 0 : _e.address) ?? "" : "";
    migratedAccountSettings.aw.enabled = ((_g = (_f = wallet.settings) == null ? void 0 : _f.autoWithdrawal) == null ? void 0 : _g.enabled) ?? true;
    migratedAccountSettings.aum.enabled = true;
    migratedAccountSettings.sendAll.enabled = ((_i = (_h = wallet.settings) == null ? void 0 : _h.enableSendAll) == null ? void 0 : _i.enabled) ?? true;
    migratedAccountSettings.tf.enabled = ((_k = (_j = wallet.settings) == null ? void 0 : _j.tokenFragmentation) == null ? void 0 : _k.enabled) ?? true;
    migratedAccountSettings.tf.bundleSize = migratedAccountSettings.tf.enabled ? ((_n = (_m = (_l = wallet.settings) == null ? void 0 : _l.tokenFragmentation) == null ? void 0 : _m.value) == null ? void 0 : _n.fragment) ?? 20 : 20;
    migratedAccountSettings.collateral.enabled = ((_p = (_o = wallet.settings) == null ? void 0 : _o.enableCollateral) == null ? void 0 : _p.enabled) ?? true;
    migratedAccountSettings.manualSync.enabled = ((_r = (_q = wallet.settings) == null ? void 0 : _q.enableManualSync) == null ? void 0 : _r.enabled) ?? false;
    for (const account of wallet.accounts) {
      const accountId = account.pub.slice(0, 16);
      tmpWalletV2.accountList.push(createIAccount({
        id: accountId,
        pub: account.pub,
        path: account.path,
        signType: dbEntry.signType
      }));
      const _migratedAccountSettings = createIAccountSettings(accountId, tmpWalletV2.networkId, migratedAccountSettings);
      if ((((_s = account.txNoteList) == null ? void 0 : _s.length) ?? 0) > 0) {
        await putLegacyNotes(account.txNoteList);
      }
      if ((((_t = account.catalystData) == null ? void 0 : _t.minVersion) ?? 0) >= 10) {
        _migratedAccountSettings.catalyst_cip15.encryptedKey = account.catalystData.encryptedKey;
        _migratedAccountSettings.catalyst_cip15.minVersion = account.catalystData.minVersion;
      }
      migratedAccountSettingsList.push(_migratedAccountSettings);
    }
    const migratedWalletSettings = createIWalletSettings(tmpWalletV2.id, tmpWalletV2.networkId, dbEntry);
    const { added } = await addWallet(tmpWalletV2, migratedWalletSettings, migratedAccountSettingsList);
    const wasAdded = added.some((wallet2) => wallet2.id === tmpWalletV2.id);
    if (wallet.addressBook) {
      const walletAddressBook = createIAddressBook("global", tmpWalletV2.networkId);
      walletAddressBook.entryList.push(...wallet.addressBook);
      await mergeAddressBook(walletAddressBook);
    }
    return wasAdded;
  }
  return false;
};
const decryptIWalletV1 = (encrWallet, pin) => {
  return JSON.parse(decryptText(encrWallet, pin));
};
let _walletPin = getAppInfo().token + "2eQ%IUufTpA#&j4J" + getAppInfo().pen;
const checkPin = (pin) => pin ?? _walletPin;
const unlockWallet = (dbEntry, pin) => {
  try {
    if (dbEntry.encryptedWallet !== null) {
      return decryptIWalletV1(dbEntry.encryptedWallet, checkPin(pin));
    }
  } catch (e) {
  }
  return null;
};
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "MigrationAccessPasswordModal",
  props: {
    showModal: { type: Object, required: true },
    textId: { type: String, required: false, default: "wallet.settings.unlock" },
    walletName: { type: String, required: false }
  },
  emits: ["submit", "close"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { t, it } = useTranslation();
    async function onPasswordSubmit(payload) {
      emit("submit", payload);
    }
    return (_ctx, _cache) => {
      return __props.showModal.display ? (openBlock(), createBlock(_sfc_main$4, {
        key: 0,
        "show-modal": __props.showModal.display,
        title: unref(it)("wallet.settings.accessPassword.labelMigration") + __props.walletName ? "(" + __props.walletName + ")" : "",
        caption: unref(it)("wallet.settings.accessPassword.captionMigration"),
        "submit-button-label": unref(it)("common.label.unlock"),
        autofocus: true,
        onClose: _cache[0] || (_cache[0] = ($event) => emit("close")),
        onSubmit: onPasswordSubmit
      }, null, 8, ["show-modal", "title", "caption", "submit-button-label"])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$2 = { class: "w-full col-span-12 lg:col-span-6 grid grid-cols-12 cc-gap" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "ImportWalletJson",
  setup(__props) {
    const $q = useQuasar();
    const { it } = useTranslation();
    const inputRef = ref(null);
    const showPasswordModal = ref({ display: false });
    const dbEntryRef = ref(null);
    const _rememberedPasswords = [];
    onMounted(() => {
      if (inputRef.value) {
        inputRef.value.addEventListener("change", onHandleFileSelect, false);
      }
    });
    function importWallet() {
      if (inputRef.value) inputRef.value.click();
    }
    let _password = null;
    function onClosePasswordModal() {
      _password = null;
      showPasswordModal.value.display = false;
    }
    function onSubmitPasswordModal(payload) {
      _password = payload.password;
      _rememberedPasswords.push(_password);
      showPasswordModal.value.display = false;
    }
    const requestPassword = async (dbEntry) => {
      _password = null;
      dbEntryRef.value = dbEntry;
      showPasswordModal.value.display = true;
      while (showPasswordModal.value.display) {
        await sleepDefault();
      }
      return _password;
    };
    const processFile = async (jsonObj) => {
      var _a;
      if ((_a = jsonObj == null ? void 0 : jsonObj.wallet) == null ? void 0 : _a.networkId) {
        return await importV2Backup(jsonObj);
      }
      if (jsonObj == null ? void 0 : jsonObj.network) {
        return await importV1Backup(jsonObj);
      }
      return null;
    };
    const importV2Backup = async (jsonObj) => {
      try {
        const _walletData = createIWallet(jsonObj == null ? void 0 : jsonObj.wallet);
        _walletData.networkId = networkId.value;
        const _walletSettings = createIWalletSettings(_walletData.id, _walletData.networkId, jsonObj == null ? void 0 : jsonObj.settings);
        if (networkId.value !== _walletData.networkId) {
          showNotificationError("Wrong wallet network id: " + _walletData.networkId + " (you are on '" + networkId.value + "')");
          return null;
        }
        if (hasWallet(_walletData.id)) {
          showNotificationWarning("Wallet '" + _walletSettings.name + "' already exists.");
          return _walletData.id;
        }
        if (jsonObj.accountList && Array.isArray(jsonObj.accountList)) {
          addLegacySettings(jsonObj.accountList.map((item) => item == null ? void 0 : item.settings));
        }
        const { added, notAdded } = await addWallet(_walletData, _walletSettings);
        if (added) {
          showNotificationSuccess("Successfully restored '" + _walletSettings.name + "'");
          return _walletData.id;
        } else {
          showNotificationError("Wasn't able to restore wallet '" + _walletSettings.name + "'");
          return null;
        }
      } catch (err) {
        console.error(err);
        showNotificationError("Could not process file: " + (jsonObj == null ? void 0 : jsonObj.name));
        return null;
      }
    };
    const importV1Backup = async (jsonObj) => {
      try {
        const dbEntry = createIWalletDBEntry(jsonObj, jsonObj.name);
        updateIWalletDBEntry(dbEntry, jsonObj);
        if (isValidIWalletDBEntry(dbEntry)) {
          if (networkId.value !== dbEntry.network) {
            showNotificationError("Wrong wallet network id: " + dbEntry.network + " (you are on '" + networkId.value + "')");
            return null;
          }
          if (hasWallet(dbEntry.id)) {
            showNotificationWarning("Wallet '" + dbEntry.name + "' already exists.");
            return dbEntry.id;
          }
          let wallet = unlockWallet(dbEntry, null);
          if (!wallet) {
            for (const password of _rememberedPasswords) {
              wallet = unlockWallet(dbEntry, password);
              if (wallet) {
                break;
              }
            }
          }
          if (!wallet) {
            wallet = unlockWallet(dbEntry, await requestPassword(dbEntry));
          }
          if (wallet) {
            const added = await addToCoreV2(dbEntry, wallet);
            if (added) {
              showNotificationSuccess("Successfully migrated '" + dbEntry.name + "'");
              return dbEntry.id;
            } else {
              showNotificationError("Wasn't able to migrate wallet '" + dbEntry.name + "'");
              return null;
            }
          } else {
            showNotificationError("Wrong password: skipping import of '" + dbEntry.name + "'");
            return null;
          }
        }
      } catch (err) {
        console.error(err);
        showNotificationError("Could not process file: " + (jsonObj == null ? void 0 : jsonObj.name));
        return null;
      }
    };
    const onHandleFileSelect = async (e) => {
      const files = e.target.files;
      const calls = [];
      for (const file of files) {
        if (!file.type.match("application/json")) {
          showNotificationWarning("Unsupported file type: " + file.type);
          continue;
        }
        calls.push(loadFile(file));
      }
      const loadedFiles = await Promise.all(calls);
      for (const file of loadedFiles) {
        await processFile(file);
      }
      inputRef.value.value = null;
    };
    const showNotificationError = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const showNotificationWarning = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const showNotificationSuccess = (msg) => {
      $q.notify({
        message: msg,
        type: "positive",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const loadFile = (file) => {
      const reader = new FileReader();
      return new Promise(async (resolve, reject) => {
        reader.onload = async (re) => {
          try {
            const loadedFile = JSON.parse(re.target.result);
            return resolve(loadedFile);
          } catch (err) {
            showNotificationError("Could not parse: " + (file == null ? void 0 : file.name));
            console.error("Could not parse:", file == null ? void 0 : file.name);
          }
          return reject("error 1");
        };
        reader.onerror = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 2");
        };
        reader.onabort = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 3");
        };
        reader.readAsText(file);
      });
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        createVNode(_sfc_main$5, {
          label: unref(it)("wallet.importsOld.json.headline"),
          "do-capitalize": false
        }, null, 8, ["label"]),
        createVNode(_sfc_main$6, {
          text: unref(it)("wallet.importsOld.json.caption")
        }, null, 8, ["text"]),
        createVNode(_sfc_main$7, {
          class: "col-span-8 lg:col-span-9",
          link: importWallet,
          label: unref(it)("common.label.importWallet"),
          icon: "mdi mdi-import"
        }, null, 8, ["label"]),
        createBaseVNode("input", {
          type: "file",
          id: "files",
          name: "files[]",
          multiple: "",
          ref_key: "inputRef",
          ref: inputRef,
          hidden: ""
        }, null, 512),
        createVNode(GridSpace, {
          hr: "",
          class: "my-0.5 sm:my-2"
        }),
        dbEntryRef.value ? (openBlock(), createBlock(_sfc_main$3, {
          key: 0,
          "show-modal": showPasswordModal.value,
          "wallet-name": dbEntryRef.value.name,
          onClose: onClosePasswordModal,
          onSubmit: onSubmitPasswordModal
        }, null, 8, ["show-modal", "wallet-name"])) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$1 = { class: "w-full col-span-12 lg:col-span-6 grid grid-cols-12 cc-gap" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "ImportAccountKey",
  setup(__props) {
    const { it } = useTranslation();
    const { gotoPage } = useNavigation();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createVNode(_sfc_main$5, {
          label: unref(it)("common.accountkey.headline"),
          "do-capitalize": false
        }, null, 8, ["label"]),
        createVNode(_sfc_main$6, {
          text: unref(it)("common.accountkey.caption")
        }, null, 8, ["text"]),
        createVNode(_sfc_main$7, {
          class: "col-span-8 lg:col-span-9",
          link: () => {
            unref(gotoPage)("WalletImportKey");
          },
          label: unref(it)("common.accountkey.button.label"),
          icon: "mdi mdi-import"
        }, null, 8, ["link", "label"]),
        createVNode(GridSpace, {
          hr: "",
          class: "my-0.5 sm:my-2"
        })
      ]);
    };
  }
});
const _hoisted_1 = { class: "min-h-16 sm:min-h-20 w-full max-w-full p-3 text-center flex flex-col flex-nowrap justify-center items-center border-t border-b mb-px cc-text-sz cc-bg-white-0" };
const _hoisted_2 = { class: "cc-text-semi-bold" };
const _hoisted_3 = { class: "" };
const _hoisted_4 = { class: "cc-page-wallet cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Import",
  setup(__props) {
    const { it } = useTranslation();
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$8, {
        containerCSS: "",
        "align-top": ""
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("span", _hoisted_2, toDisplayString(unref(it)("wallet.imports.headline")), 1),
            createBaseVNode("span", _hoisted_3, toDisplayString(unref(it)("wallet.imports.caption")), 1)
          ])
        ]),
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_4, [
            createVNode(_sfc_main$2),
            createVNode(_sfc_main$1)
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
