import { ey as useResetScroll, K as networkId, iN as getRouter } from "./index.js";
import { u as useTabId } from "./useTabId.js";
const getParams = (gotoNetworkId, gotoWalletId) => {
  const params = {};
  if (gotoNetworkId) {
    params.networkid = gotoNetworkId;
  }
  if (gotoWalletId) {
    params.walletid = gotoWalletId;
  }
  return params;
};
const goto = (pageList, walletId, tabId) => {
  const router = getRouter();
  const page = pageList.shift();
  if (page && router) {
    if (tabId) {
      useTabId().updateTabId(tabId, page);
    }
    router.push({ name: page, params: getParams(networkId.value ?? "mainnet", walletId) });
  } else {
    if (pageList.length > 0) {
      goto(pageList);
    }
  }
};
const gotoHome = () => goto(["LandingPage"]);
const gotoWalletList = () => goto(["Wallets", "LandingPage"]);
const gotoPage = (page) => goto([page, "LandingPage"]);
const gotoDAppBrowserPage = (page, tabid) => goto([page, "LandingPage"], void 0, tabid);
const gotoDirectConnect = (page, tabid) => goto([page, "LandingPage"], void 0, tabid);
const gotoWalletPage = (page, tabId) => openWalletPage(page, void 0, tabId);
const openWalletPage = (page, walletId, tabId) => {
  useResetScroll().resetScroll();
  goto([page, "Wallets", "LandingPage"], walletId, tabId);
};
const openWallet = (walletId, page = "Summary", tabId = "summary") => {
  openWalletPage(page, walletId, tabId);
};
const useNavigation = () => {
  return {
    openWallet,
    openWalletPage,
    gotoHome,
    gotoPage,
    gotoDAppBrowserPage,
    // gotoDAppBrowserAndOpen,
    gotoDirectConnect,
    gotoWalletList,
    gotoWalletPage
    // payload
  };
};
export {
  useNavigation as u
};
