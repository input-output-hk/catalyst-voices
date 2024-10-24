// TODO(dtscalac): replace with actual key derivation, for not it's just a copy of catalyst_compression

// initial message handler from the main thread.
self.onmessage = (event) => {
    const { id } = event.data;
    self.postMessage({ id, error: 'Worker is not ready' });
};

Promise.all([
    import('https://unpkg.com/brotli-wasm@3.0.0/index.web.js?module').then(m => m.default),
    import('https://unpkg.com/@oneidentity/zstd-js@1.0.3/wasm/index.js?module')
]).then(async ([brotli, zstd]) => {
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

    const catalyst_compression = {
        brotliCompress: _brotliCompress,
        brotliDecompress: _brotliDecompress,
        zstdCompress: _zstdCompress,
        zstdDecompress: _zstdDecompress,
    };

    // replace the initial handler with the actual handler.
    self.onmessage = (event) => {
        const { id, action, bytesHex } = event.data;
        if (catalyst_compression[action]) {
            try {
                const result = catalyst_compression[action](bytesHex);
                self.postMessage({ id, result });
            } catch (error) {
                self.postMessage({ id, error: error.message });
            }
        } else {
            self.postMessage({ id, error: 'Unknown action' });
        }
    };

    // send an event to notify the main thread that the worker is ready.
    self.postMessage({ initialized: true });
}).catch(error => {
    self.postMessage({ error: `Failed to load modules: ${error.message}` });
})