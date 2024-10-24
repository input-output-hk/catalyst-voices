// Initialize a web worker for key derivation works.
// This is a persistent worker, will last for life of the app.
const keyDerivationWorker = new Worker(new URL('./catalyst_key_derivation_worker.js', import.meta.url));

let idCounter = 0;

// A simple id generator function.
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

// A function to create a key derivation function according to its name.
function runKeyDerivationInWorker(fnName) {
    return (data) => {
        return new Promise((resolve, reject) => {
            const id = generateId();

            registerWorkerEventHandler(
                keyDerivationWorker,
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

            keyDerivationWorker.postMessage({ id, action: fnName, bytesHex: data });
        });
    }
}

// A namespace containing the JS functions that
// can be executed from dart side
const catalyst_key_derivation = {
    // TODO(dtscalac): replace by actual key derivation, for now lets leave catalyst_compression copy
    brotliCompress: runKeyDerivationInWorker("brotliCompress"),
    brotliDecompress: runKeyDerivationInWorker("brotliDecompress"),
    zstdCompress: runKeyDerivationInWorker("zstdCompress"),
    zstdDecompress: runKeyDerivationInWorker("zstdDecompress"),
};

// Expose catalyst key derivation as globally accessible
// so that we can call it via catalyst_key_derivation.function_name() from
// other scripts or dart without needing to care about module imports
window.catalyst_key_derivation = catalyst_key_derivation;
