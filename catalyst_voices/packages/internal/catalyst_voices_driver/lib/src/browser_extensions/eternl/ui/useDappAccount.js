import { a6 as useAppWallet, e5 as dappWalletId, e6 as useWalletSettings, e7 as useAppAccount, g as dappAccountId, e8 as useAppAccountBalances, e9 as useAccountSettings, f as computed } from "./index.js";
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
