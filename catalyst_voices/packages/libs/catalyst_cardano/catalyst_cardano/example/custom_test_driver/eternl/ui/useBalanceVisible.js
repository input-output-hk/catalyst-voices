import { aF as getObjRef, i_ as getRef, i$ as forceSetLS, f as computed } from "./index.js";
const getBalanceVisible = () => getObjRef("balanceVisible", true);
const getDarkMode = () => getRef("darkMode_", "1");
const toggleDarkMode = () => {
  const _ref = getDarkMode();
  _ref.value = _ref.value === "1" ? "0" : "1";
  forceSetLS("darkMode_", _ref.value);
};
const balanceVisible = getBalanceVisible();
const useBalanceVisible = () => {
  const setBalanceVisible = (visible) => {
    balanceVisible.value = visible;
  };
  const isBalanceVisible = computed(() => balanceVisible.value);
  return {
    isBalanceVisible,
    setBalanceVisible
  };
};
export {
  getDarkMode as g,
  toggleDarkMode as t,
  useBalanceVisible as u
};
