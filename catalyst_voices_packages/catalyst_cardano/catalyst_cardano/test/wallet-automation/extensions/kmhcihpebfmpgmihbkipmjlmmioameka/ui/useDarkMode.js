import { g as getDarkMode, t as toggleDarkMode } from "./useBalanceVisible.js";
import { f as computed } from "./index.js";
const darkMode = getDarkMode();
const useDarkMode = () => {
  const isDarkMode = computed(() => darkMode.value === "1");
  return {
    isDarkMode,
    toggleDarkMode
  };
};
export {
  useDarkMode as u
};
