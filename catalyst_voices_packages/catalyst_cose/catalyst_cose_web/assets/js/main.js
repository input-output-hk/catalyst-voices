const cose = require('cose-js');

/// Signs the message bytes and returns a COSE signature.
async function _signMessage(bytesHex) {
    const bytes = _hexStringToUint8Array(bytesHex);
    const headers = {
        p: { alg: 'ES256' },
        u: { kid: '11' }
    };
    const signer = {
        key: {
            d: Buffer.from('6c1382765aec5358f117733d281c1c7bdc39884d04a45a1e6c67c858bc206c19', 'hex')
        }
    };

    const buf = await cose.sign.create(headers, bytes, signer);
    return buf.toString('hex');
}


// Converts a hex string into a byte array.
function _hexStringToUint8Array(hexString) {
    // Ensure the hex string length is even
    if (hexString.length % 2 !== 0) {
        throw new Error('Invalid hex string');
    }

    // Create a Uint8Array
    const byteArray = new Uint8Array(hexString.length / 2);

    // Parse the hex string into byte values
    for (let i = 0; i < hexString.length; i += 2) {
        byteArray[i / 2] = parseInt(hexString.substr(i, 2), 16);
    }

    return byteArray;
}

// A namespace containing the JS functions that
// can be executed from dart side
const catalyst_cose = {
    signMessage: _signMessage,
}

// Expose catalyst cose as globally accessible
// so that we can call it via catalyst_cose.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_cose = catalyst_cose;