import { CardanoWalletInitialApi } from "./cardano_wallet_api.js";

// Returns available wallet extensions exposed under
// cardano.{walletName} according to CIP-30 standard.
function _getWallets() {
  const cardano = window.cardano;
  if (cardano) {
    const keys = Object.keys(window.cardano);
    const possibleWallets = keys.map((k) => cardano[k]);
    const validWallets = possibleWallets.filter(
      (w) => typeof w === "object" && "enable" in w && "apiVersion" in w
    );
    return validWallets.map((w) => new CardanoWalletInitialApi(w));
  }

  return [];
}

// A namespace containing the JS functions that
// can be executed from dart side
const catalyst_cardano = {
  getWallets: _getWallets,
};

// Expose cardano multiplatform as globally accessible
// so that we can call it via catalyst_cardano.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_cardano = catalyst_cardano;
