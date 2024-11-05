// Returns available wallet extensions exposed under
// cardano.{walletName} according to CIP-30 standard.
function _getWallets() {
    const cardano = window.cardano;
    if (cardano) {
        const keys = Object.keys(window.cardano);
        const possibleWallets = keys.map((k) => cardano[k]);
        return possibleWallets.filter((w) => typeof w === "object" && "enable" in w && "apiVersion" in w);
    }

    return [];
}

// Returns an instance of `undefined` to dart layer as `undefined`
// cannot be constructed directly in dart layer. Dart nulls are translated
// to JS nulls and JS distinguishes between undefined and null.
function _makeUndefined() {
    return undefined;
}

// A namespace containing the JS functions that
// can be executed from dart side
const catalyst_cardano = {
    getWallets: _getWallets,
    makeUndefined: _makeUndefined,
}

// Expose cardano multiplatform as globally accessible
// so that we can call it via catalyst_cardano.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_cardano = catalyst_cardano;