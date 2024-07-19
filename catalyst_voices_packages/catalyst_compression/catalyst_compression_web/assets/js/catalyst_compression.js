const brotli = await import("https://unpkg.com/brotli-wasm@3.0.0/index.web.js?module").then(m => m.default);
const zstd = await import("https://unpkg.com/@oneidentity/zstd-js@1.0.3/wasm/index.js?module");

// Initializes the zstd module, must be called before it can be used.
await zstd.ZstdInit();

/// Compresses hex bytes using brotli compression algorithm and returns compressed hex bytes.
function _brotliCompress(bytesHex) {
    const bytes = _hexStringToUint8Array(bytesHex);
    const compressedBytes = brotli.compress(bytes);
    return _uint8ArrayToHexString(compressedBytes);
}

/// Decompresses hex bytes using brotli compression algorithm and returns decompressed hex bytes.
function _brotliDecompress(bytesHex) {
    const bytes = _hexStringToUint8Array(bytesHex);
    const decompressedBytes = brotli.decompress(bytes);
    return _uint8ArrayToHexString(decompressedBytes);
}

/// Compresses hex bytes using zstd compression algorithm and returns compressed hex bytes.
function _zstdCompress(bytesHex) {
    const bytes = _hexStringToUint8Array(bytesHex);
    const compressedBytes = zstd.ZstdSimple.compress(bytes);
    return _uint8ArrayToHexString(compressedBytes);
}

/// Decompresses hex bytes using zstd compression algorithm and returns decompressed hex bytes.
function _zstdDecompress(bytesHex) {
    const bytes = _hexStringToUint8Array(bytesHex);
    const decompressedBytes = zstd.ZstdSimple.decompress(bytes);
    return _uint8ArrayToHexString(decompressedBytes);
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

// Converts a byte array into a hex string.
function _uint8ArrayToHexString(uint8Array) {
    return Array.from(uint8Array)
        .map(byte => byte.toString(16).padStart(2, '0'))
        .join('');
}


// A namespace containing the JS functions that
// can be executed from dart side
const catalyst_compression = {
    brotliCompress: _brotliCompress,
    brotliDecompress: _brotliDecompress,
    zstdCompress: _zstdCompress,
    zstdDecompress: _zstdDecompress,
}

// Expose catalyst compression as globally accessible
// so that we can call it via catalyst_compression.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_compression = catalyst_compression;