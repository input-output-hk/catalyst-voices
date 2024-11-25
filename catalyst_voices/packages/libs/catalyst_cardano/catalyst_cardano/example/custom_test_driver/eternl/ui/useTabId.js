import { z as ref, iN as getRouter } from "./index.js";
const _tabId = ref(null);
const updateTabId = (tabId, pageName) => {
  if (_tabId.value !== tabId) {
    _tabId.value = tabId;
    const router = getRouter();
    if (router) {
      let removeQuery = true;
      if (pageName === "Summary") {
        if (tabId === "summary" || tabId === "tokens" || tabId === "utxos" || tabId === "accounts") {
          router.push({ query: { t: tabId } });
          removeQuery = false;
        }
      }
      if (removeQuery) {
        router.replace({ query: { t: void 0 } });
      }
    }
  }
  return _tabId.value !== null;
};
function useTabId() {
  return {
    updateTabId,
    tabId: _tabId
  };
}
export {
  useTabId as u
};
