// Initialize a web worker for compression works.
// This is a persistent worker, will last for life of the app.
const compressionWorker = new Worker(new URL('./catalyst_compression_worker.js', import.meta.url));

let idCounter = 0;

// A simple id generator function. The generated id must be unique across all the processing ids.
function generateId() {
    const thisId = idCounter;
    const nextId = idCounter + 1;

    idCounter = nextId >= Number.MAX_SAFE_INTEGER ? 0 : nextId;

    return thisId;
}

function registerWorkerEventHandler(worker, handleMessage, handleError) {
    const wrappedHandleMessage = (event) => handleMessage(event, complete);
    const wrappedHandleError = (error) => handleError(error, complete);

    function complete() {
        worker.removeEventListener("message", wrappedHandleMessage);
        worker.removeEventListener("error", wrappedHandleError);
    }

    worker.addEventListener("message", wrappedHandleMessage);
    worker.addEventListener("error", wrappedHandleError);
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
                        resolve(result);
                    } else {
                        reject(error || 'Unexpected error');
                    }

                    complete();
                },
                (error, complete) => {
                    reject(error);

                    complete();
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
};

// Expose catalyst compression as globally accessible
// so that we can call it via catalyst_compression.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_compression = catalyst_compression;
