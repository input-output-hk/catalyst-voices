import { h as networkGroups } from "./NetworkId.js";
import { f as computed, K as networkId, aS as isTestnet } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
function useAdaSymbol() {
  const { it } = useTranslation();
  const adaSymbol = computed(() => {
    if (networkGroups.APEX.includes(networkId.value)) {
      return isTestnet.value ? it("common.symbol.tapex") : it("common.symbol.apex");
    } else {
      return isTestnet.value ? it("common.symbol.tada") : it("common.symbol.ada");
    }
  });
  return {
    adaSymbol
  };
}
export {
  useAdaSymbol as u
};
