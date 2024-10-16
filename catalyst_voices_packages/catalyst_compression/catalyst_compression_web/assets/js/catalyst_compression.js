function runCompressionInWorker(fnName) {
    return (data) => {
        return new Promise((resolve, reject) => {
            const compressionWorker = new Worker('/catalyst_voices_packages/catalyst_compression/catalyst_compression_web/assets/js/catalyst_compression_worker.js');
    
            compressionWorker.onmessage = (event) => {
                const { result, initialized, error } = event.data;
                if (initialized) {
                    compressionWorker.postMessage({ action: fnName, bytesHex: data });
                } else if (result) {
                    resolve(result);
                    compressionWorker.terminate()
                } else {
                    reject(error || null);
                    compressionWorker.terminate()
                }
            };
    
            compressionWorker.onerror = (error) => {
                reject(error);
                compressionWorker.terminate()
            };
        });
    }
}

// A namespace containing the JS functions that
// can be executed from dart side
const catalyst_compression = {
    brotliCompress: runCompressionInWorker("brotliCompress"),
    brotliDecompress: runCompressionInWorker("brotliDecompress"),
    zstdCompress: runCompressionInWorker("zstdCompress"),
    zstdDecompress: runCompressionInWorker("zstdDecompress"),
}

// Expose catalyst compression as globally accessible
// so that we can call it via catalyst_compression.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_compression = catalyst_compression;