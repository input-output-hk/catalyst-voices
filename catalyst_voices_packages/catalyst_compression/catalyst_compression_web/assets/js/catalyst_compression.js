// initialize a web worker for compression works.
// this is a persistent worker, will last for life of the app.
const compressionWorker = new Worker('/assets/packages/catalyst_compression_web/assets/js/catalyst_compression_worker.js');

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

function registerWorkerEventHandler(worker, handleMessage, handleError) {
    const wrappedHandleMessage = (event) => handleMessage(event, complete);
    const wrappedHandleError = (error) => handleError(error, complete);

    function complete() {
        worker.removeEventListener("message", wrappedHandleMessage);
        worker.removeEventListener("error", wrappedHandleError)
    }

    worker.addEventListener("message", wrappedHandleMessage)
    worker.addEventListener("error", wrappedHandleError)
}

// A function to create a compression function according to its name.
function runCompressionInWorker(fnName) {
    return (data) => {
        return new Promise((resolve, reject) => {
            const id = generateId();

            registerWorkerEventHandler(
                compressionWorker,
                (event, complete) => {
                    const {
                        id: responseId,
                        result,
                        error,
                        initialized
                    } = event.data;
    
                    // skip the initializing completion event,
                    // and the id that is not itself.
                    if (initialized || responseId !== id) {
                        return;
                    }
    
                    if (result) {
                        complete(resolve(result));
                    } else {
                        complete(reject(error || 'Unexpected error'));
                    }
    
                    processingIdsPool.delete(id);
                },
                (error, complete) => {
                    complete(reject(error));
    
                    processingIdsPool.clear();
                }
            );

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