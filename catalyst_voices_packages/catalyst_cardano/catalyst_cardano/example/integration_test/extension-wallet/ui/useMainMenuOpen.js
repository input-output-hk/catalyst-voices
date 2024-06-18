import { z as ref, f as computed } from "./index.js";
const mainMenuOpen = ref(false);
const useMainMenuOpen = () => {
  const openMainMenu = () => {
    mainMenuOpen.value = true;
  };
  const closeMainMenu = () => {
    mainMenuOpen.value = false;
  };
  const toggleMainMenu = () => {
    mainMenuOpen.value = !mainMenuOpen.value;
  };
  const isMainMenuOpen = computed(() => mainMenuOpen.value);
  return {
    openMainMenu,
    closeMainMenu,
    toggleMainMenu,
    isMainMenuOpen
  };
};
export {
  useMainMenuOpen as u
};
