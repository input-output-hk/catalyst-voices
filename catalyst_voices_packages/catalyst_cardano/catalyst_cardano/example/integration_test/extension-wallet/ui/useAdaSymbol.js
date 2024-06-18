import { f as computed, aN as isTestnet } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
function useAdaSymbol() {
  const { it } = useTranslation();
  const adaSymbol = computed(() => isTestnet.value ? it("common.symbol.tada") : it("common.symbol.ada"));
  return {
    adaSymbol
  };
}
export {
  useAdaSymbol as u
};
