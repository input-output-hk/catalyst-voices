import { a8 as useAppWallet, d_ as dappWalletId, d$ as useWalletSettings, e0 as useAppAccount, g as dappAccountId, e1 as useAppAccountBalances, e2 as useAccountSettings, f as computed } from "./index.js";
const appWallet = useAppWallet(dappWalletId);
const walletSettings = useWalletSettings(appWallet);
const walletData = walletSettings.data;
const appAccount = useAppAccount(appWallet, dappAccountId);
const appAccountBalances = useAppAccountBalances(appAccount);
const accountSettings = useAccountSettings(appAccount);
const accountData = accountSettings.data;
const utxoMap = accountSettings.utxoMap;
const hasDappAccount = computed(() => !!appWallet.value);
const hasDappWallet = computed(() => !!appAccount.value);
const isDappWallet = (walletId) => !!walletId && walletId === dappWalletId.value;
function useDappAccount() {
  return {
    hasDappAccount,
    hasDappWallet,
    dappAccountId,
    dappWalletId,
    dappWallet: appWallet,
    dappAccount: appAccount,
    walletData,
    walletSettings,
    accountData,
    accountSettings,
    accountBalances: appAccountBalances,
    utxoMap,
    isDappWallet
  };
}
export {
  useDappAccount as u
};
