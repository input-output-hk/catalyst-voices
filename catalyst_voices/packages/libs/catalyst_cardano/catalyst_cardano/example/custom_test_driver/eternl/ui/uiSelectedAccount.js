import { z as ref, f as computed, db as getIAppWallet, dc as purpose, dd as isHDAccount } from "./index.js";
const _setUiSelectedWalletId = (_walletId, walletId) => {
  if (_walletId.value !== walletId) {
    _walletId.value = walletId;
  }
};
const _setUiSelectedAccountId = (_accountId, accountId) => {
  if (_accountId.value !== accountId) {
    _accountId.value = accountId;
  }
};
const useUiSelectedAccount = () => {
  const _walletId = ref("");
  const _accountId = ref("");
  const uiSelectedWalletId = computed(() => _walletId.value);
  const uiSelectedAccountId = computed(() => _accountId.value);
  const setUiSelectedWalletId = (walletId, preselectAccount = true) => {
    let changed = false;
    const appWallet = getIAppWallet(walletId);
    if (!appWallet) {
      changed = uiSelectedWalletId.value !== walletId;
      _setUiSelectedWalletId(_walletId, "");
      _setUiSelectedAccountId(_accountId, "");
      return changed;
    }
    if (uiSelectedWalletId.value !== walletId) {
      _setUiSelectedWalletId(_walletId, walletId);
      changed = true;
      if (preselectAccount && !appWallet.data.wallet.accountList.some((account) => account.id === uiSelectedAccountId.value)) {
        setUiWalletAccountId(appWallet);
      }
    }
    return changed;
  };
  const setUiWalletAccountId = (appWallet) => {
    let accountId = "";
    if (appWallet.data.wallet.accountList.length > 0) {
      const accountList = appWallet.data.wallet.accountList.sort((a, b) => {
        if (a.path[0] === purpose.hdwallet && b.path[0] !== purpose.hdwallet) return -1;
        if (a.path[0] !== purpose.hdwallet && b.path[0] === purpose.hdwallet) return 1;
        return a.path[2] - b.path[2];
      });
      const account = accountList[0];
      if (isHDAccount(account.path)) {
        accountId = accountList[0].id;
      }
    }
    if (uiSelectedAccountId.value !== accountId) {
      _setUiSelectedAccountId(_accountId, accountId);
    }
    return accountId;
  };
  const setUiSelectedAccountId = (accountId, preselectWalletAccount = true) => {
    let changed = false;
    const appWallet = getIAppWallet(uiSelectedWalletId.value);
    if (!appWallet) {
      if (uiSelectedWalletId.value !== "" || uiSelectedAccountId.value !== "") {
        _setUiSelectedWalletId(_walletId, "");
        _setUiSelectedAccountId(_accountId, "");
        changed = true;
      }
      return changed;
    }
    if (preselectWalletAccount && !appWallet.data.wallet.accountList.some((account2) => account2.id === accountId)) {
      setUiWalletAccountId(appWallet);
      return changed;
    }
    const account = appWallet.data.wallet.accountList.find((account2) => account2.id === accountId);
    if (!account || !isHDAccount(account.path)) ;
    else if (uiSelectedAccountId.value !== accountId) {
      _setUiSelectedAccountId(_accountId, accountId);
      changed = true;
    }
    return changed;
  };
  return {
    uiSelectedWalletId,
    uiSelectedAccountId,
    setUiSelectedWalletId,
    setUiSelectedAccountId
  };
};
export {
  useUiSelectedAccount as u
};
