import init, * as cardano_multiplatform_lib from './cardano_multiplatform_lib.js';

// since cardano_multiplatform_lib is not extensible import,
// lets create a wrapper, put all functions from cardano multiplatform
// and include the missing ones
const catalyst_cardano = {
    init: init,
    ...cardano_multiplatform_lib,
}

// expose cardano multiplatform as globally accessible
// so that we can call it via catalyst_cardano.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_cardano = catalyst_cardano;