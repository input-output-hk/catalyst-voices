import { hf as createIWalletDBData, z as ref, hg as warn, ek as hasWallet, hh as prepareAccountKey, U as reactive, hi as createMnemonicWallet, hj as createReadonlyWallet, hk as createHardwareWallet, er as addWallet, c8 as json, ew as createPrvKeyRoot, hl as getPubKeyFromPrvKey, hm as generateWalletId } from "./index.js";
createIWalletDBData();
const _walletName = ref(null);
const _spendingPassword = ref(null);
const _mnemonic = ref(null);
const _accountPubBech32List = ref([]);
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
  const _walletData2 = signType === "mnemonic" ? await createMnemonicWallet(networkId, _mnemonic.value, _spendingPassword.value, numAccounts) : signType === "readonly" ? await createReadonlyWallet(networkId, _accountPubBech32List.value) : await createHardwareWallet(networkId, signType, _accountPubBech32List.value, suffix, masterFingerprint);
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
    // setNumberOfAccounts,
    // setDiscoverAccounts,
    // setWalletCreationHook,
    //
    generateWalletIdFromMnemonic,
    generateWalletIdFromPubBech32,
    createWallet
    // createWalletFromDBEntry
  };
}
export {
  useWalletCreation as u
};
