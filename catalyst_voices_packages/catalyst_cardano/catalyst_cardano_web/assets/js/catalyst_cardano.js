// queries available wallet extensions exposed with
// cardano.{wallet-name} according to CIP - 30 standard.
function _getCardanoWallets() {
    const cardano = window.cardano;
    if (cardano) {
        const keys = Object.keys(window.cardano);
        const possibleWallets = keys.map((k) => cardano[k]);
        return possibleWallets.filter((w) => typeof w === "object" && "enable" in w);
    }

    return [];
}

// a namespace containing the JS functions that
// can be executed from dart side
const catalyst_cardano = {
    getCardanoWallets: _getCardanoWallets,
}

// expose cardano multiplatform as globally accessible
// so that we can call it via catalyst_cardano.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_cardano = catalyst_cardano;