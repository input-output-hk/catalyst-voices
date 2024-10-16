// initialize a web worker for compression works.
// this is a persistent worker, will last for life of the app.
const compressionWorker = new Worker('/catalyst_voices_packages/catalyst_compression/catalyst_compression_web/assets/js/catalyst_compression_worker.js');

const processingIdsPool = new Set();

// A simple id generator function. The generated id must be unique across all the processing ids.
function generateId() {
    let id
    do {
        const timestamp = Date.now().toString(36);
        const randomNum = Math.random().toString(36).substring(2, 8);
        id = `${timestamp}-${randomNum}`;
    } while (processingIdsPool.has(id));
    processingIdsPool.add(id);

    return id;
}

function removeWorkerListener(onMessage, onError) {
    compressionWorker.removeEventListener("message", onMessage);
    compressionWorker.removeEventListener("error", onError);
}

// A function to create a compression function according to its name.
function runCompressionInWorker(fnName) {
    return (data) => {
        return new Promise((resolve, reject) => {
            const id = generateId();

            const handleMessage = (event) => {
                const {
                    id: responseId,
                    result,
                    error,
                    initialized
                } = event.data;

                // skip the initialized completion event,
                // and the id that is not itself.
                if (initialized || responseId !== id) {
                    return;
                }

                if (result) {
                    resolve(result);
                } else {
                    reject(error || null);
                }

                processingIdsPool.delete(id);

                removeWorkerListener(handleMessage, handleError);
            };
            const handleError = (error) => {
                reject(error);

                processingIdsPool.clear();

                removeWorkerListener(handleMessage, handleError);
            };

            compressionWorker.addEventListener("message", handleMessage);
            compressionWorker.addEventListener("error", handleError);

            compressionWorker.postMessage({ id, action: fnName, bytesHex: data });
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