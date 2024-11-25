import { hg as createIWalletDBData, z as ref, hh as warn, ed as hasWallet, hi as prepareAccountKey, S as reactive, hj as createMnemonicWallet, hk as createReadonlyWallet, hl as createHardwareWallet, ek as addWallet, bT as json, ep as createPrvKeyRoot, hm as getPubKeyFromPrvKey, hn as generateWalletId } from "./index.js";
createIWalletDBData();
const _walletName = ref(null);
const _spendingPassword = ref(null);
const _mnemonic = ref(null);
const _accountPubBech32List = ref([]);
const _multiSigPub = ref(null);
const _multiSigPath = ref([]);
ref(1);
ref(false);
const setWalletName = (walletName) => {
  _walletName.value = walletName;
};
const setMnemonic = (mnemonic) => {
  _mnemonic.value = mnemonic;
};
const setSpendingPassword = (spendingPassword) => {
  _spendingPassword.value = spendingPassword;
};
const setMultiSig = (pub, path) => {
  _multiSigPub.value = pub;
  _multiSigPath.value = path;
};
const setAccountPubBech32List = (list) => {
  _accountPubBech32List.value.splice(0);
  for (const bech32 of list) {
    _accountPubBech32List.value.push(prepareAccountKey(bech32));
  }
};
const resetWalletCreation = () => {
  reactive(createIWalletDBData());
};
async function createWallet(networkId, signType, numAccounts = 1, suffix, masterFingerprint) {
  if (signType === "mnemonic") {
    if (_mnemonic.value === null) {
      throw new Error("Error: createWallet: mnemonic not set.");
    }
    if (_spendingPassword.value === null) {
      throw new Error("Error: createWallet: spending password not set.");
    }
  } else {
    if (_accountPubBech32List.value.length === 0) {
      throw new Error("Error: createWallet: account pub key list not set.");
    }
  }
  const _walletData2 = signType === "mnemonic" ? await createMnemonicWallet(networkId, _mnemonic.value, _spendingPassword.value, numAccounts) : signType === "readonly" ? await createReadonlyWallet(networkId, _accountPubBech32List.value) : await createHardwareWallet(networkId, signType, _accountPubBech32List.value, _multiSigPub.value, _multiSigPath.value, suffix, masterFingerprint);
  if (_walletName.value === null) {
    throw new Error("Error: createWallet: walletName not set.");
  }
  _walletData2.settings.name = _walletName.value;
  const { added, notAdded } = await addWallet(json(_walletData2.wallet), json(_walletData2.settings));
  return added.some((wallet) => wallet.id === _walletData2.wallet.id) ? _walletData2.wallet.id : null;
}
const generateWalletIdFromMnemonic = (mnemonic, networkId, signType) => {
  if (mnemonic === null) {
    throw new Error("Error: generateWalletIdFromMnemonic: mnemonic not set.");
  }
  const prv = createPrvKeyRoot(mnemonic);
  const pub = getPubKeyFromPrvKey(prv);
  return generateWalletId(pub, networkId, signType);
};
function generateWalletIdFromPubBech32(networkId, signType, suffix) {
  if (_accountPubBech32List.value.length === 0) {
    throw new Error("Error: generateWalletIdFromPubBech32: invalid pubBech32.");
  }
  return generateWalletId(_accountPubBech32List.value[0], networkId, signType, suffix);
}
function useWalletCreation() {
  warn("useWalletCreation.init");
  return {
    hasWallet,
    setWalletName,
    setSpendingPassword,
    setMnemonic,
    resetWalletCreation,
    setAccountPubBech32List,
    setMultiSig,
    generateWalletIdFromMnemonic,
    generateWalletIdFromPubBech32,
    createWallet
  };
}
export {
  useWalletCreation as u
};
