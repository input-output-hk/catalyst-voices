let wasm_bindgen;
(function() {
    const __exports = {};
    let script_src;
    if (typeof document !== 'undefined' && document.currentScript !== null) {
        script_src = new URL(document.currentScript.src, location.href).toString();
    }
    let wasm = undefined;

    function _assertBoolean(n) {
        if (typeof(n) !== 'boolean') {
            throw new Error(`expected a boolean argument, found ${typeof(n)}`);
        }
    }

    function logError(f, args) {
        try {
            return f.apply(this, args);
        } catch (e) {
            let error = (function () {
                try {
                    return e instanceof Error ? `${e.message}\n\nStack:\n${e.stack}` : e.toString();
                } catch(_) {
                    return "<failed to stringify thrown value>";
                }
            }());
            console.error("wasm-bindgen: imported JS function that was not marked as `catch` threw an error:", error);
            throw e;
        }
    }

    function addToExternrefTable0(obj) {
        const idx = wasm.__externref_table_alloc();
        wasm.__wbindgen_export_2.set(idx, obj);
        return idx;
    }

    function handleError(f, args) {
        try {
            return f.apply(this, args);
        } catch (e) {
            const idx = addToExternrefTable0(e);
            wasm.__wbindgen_exn_store(idx);
        }
    }

    let WASM_VECTOR_LEN = 0;

    let cachedUint8ArrayMemory0 = null;

    function getUint8ArrayMemory0() {
        if (cachedUint8ArrayMemory0 === null || cachedUint8ArrayMemory0.buffer !== wasm.memory.buffer) {
            cachedUint8ArrayMemory0 = new Uint8Array(wasm.memory.buffer);
        }
        return cachedUint8ArrayMemory0;
    }

    const cachedTextEncoder = (typeof TextEncoder !== 'undefined' ? new TextEncoder('utf-8') : { encode: () => { throw Error('TextEncoder not available') } } );

    const encodeString = function (arg, view) {
        const buf = cachedTextEncoder.encode(arg);
        view.set(buf);
        return {
            read: arg.length,
            written: buf.length
        };
    };

    function passStringToWasm0(arg, malloc, realloc) {

        if (typeof(arg) !== 'string') throw new Error(`expected a string argument, found ${typeof(arg)}`);

        if (realloc === undefined) {
            const buf = cachedTextEncoder.encode(arg);
            const ptr = malloc(buf.length, 1) >>> 0;
            getUint8ArrayMemory0().subarray(ptr, ptr + buf.length).set(buf);
            WASM_VECTOR_LEN = buf.length;
            return ptr;
        }

        let len = arg.length;
        let ptr = malloc(len, 1) >>> 0;

        const mem = getUint8ArrayMemory0();

        let offset = 0;

        for (; offset < len; offset++) {
            const code = arg.charCodeAt(offset);
            if (code > 0x7F) break;
            mem[ptr + offset] = code;
        }

        if (offset !== len) {
            if (offset !== 0) {
                arg = arg.slice(offset);
            }
            ptr = realloc(ptr, len, len = offset + arg.length * 3, 1) >>> 0;
            const view = getUint8ArrayMemory0().subarray(ptr + offset, ptr + len);
            const ret = encodeString(arg, view);
            if (ret.read !== arg.length) throw new Error('failed to pass whole string');
            offset += ret.written;
            ptr = realloc(ptr, len, offset, 1) >>> 0;
        }

        WASM_VECTOR_LEN = offset;
        return ptr;
    }

    let cachedDataViewMemory0 = null;

    function getDataViewMemory0() {
        if (cachedDataViewMemory0 === null || cachedDataViewMemory0.buffer !== wasm.memory.buffer) {
            cachedDataViewMemory0 = new DataView(wasm.memory.buffer);
        }
        return cachedDataViewMemory0;
    }

    const cachedTextDecoder = (typeof TextDecoder !== 'undefined' ? new TextDecoder('utf-8', { ignoreBOM: true, fatal: true }) : { decode: () => { throw Error('TextDecoder not available') } } );

    if (typeof TextDecoder !== 'undefined') { cachedTextDecoder.decode(); };

    function getStringFromWasm0(ptr, len) {
        ptr = ptr >>> 0;
        return cachedTextDecoder.decode(getUint8ArrayMemory0().slice(ptr, ptr + len));
    }

    function _assertNum(n) {
        if (typeof(n) !== 'number') throw new Error(`expected a number argument, found ${typeof(n)}`);
    }

    function isLikeNone(x) {
        return x === undefined || x === null;
    }

    const CLOSURE_DTORS = (typeof FinalizationRegistry === 'undefined')
        ? { register: () => {}, unregister: () => {} }
        : new FinalizationRegistry(state => {
        wasm.__wbindgen_export_7.get(state.dtor)(state.a, state.b)
    });

    function makeMutClosure(arg0, arg1, dtor, f) {
        const state = { a: arg0, b: arg1, cnt: 1, dtor };
        const real = (...args) => {
            // First up with a closure we increment the internal reference
            // count. This ensures that the Rust closure environment won't
            // be deallocated while we're invoking it.
            state.cnt++;
            const a = state.a;
            state.a = 0;
            try {
                return f(a, state.b, ...args);
            } finally {
                if (--state.cnt === 0) {
                    wasm.__wbindgen_export_7.get(state.dtor)(a, state.b);
                    CLOSURE_DTORS.unregister(state);
                } else {
                    state.a = a;
                }
            }
        };
        real.original = state;
        CLOSURE_DTORS.register(real, state, state);
        return real;
    }

    function debugString(val) {
        // primitive types
        const type = typeof val;
        if (type == 'number' || type == 'boolean' || val == null) {
            return  `${val}`;
        }
        if (type == 'string') {
            return `"${val}"`;
        }
        if (type == 'symbol') {
            const description = val.description;
            if (description == null) {
                return 'Symbol';
            } else {
                return `Symbol(${description})`;
            }
        }
        if (type == 'function') {
            const name = val.name;
            if (typeof name == 'string' && name.length > 0) {
                return `Function(${name})`;
            } else {
                return 'Function';
            }
        }
        // objects
        if (Array.isArray(val)) {
            const length = val.length;
            let debug = '[';
            if (length > 0) {
                debug += debugString(val[0]);
            }
            for(let i = 1; i < length; i++) {
                debug += ', ' + debugString(val[i]);
            }
            debug += ']';
            return debug;
        }
        // Test for built-in
        const builtInMatches = /\[object ([^\]]+)\]/.exec(toString.call(val));
        let className;
        if (builtInMatches && builtInMatches.length > 1) {
            className = builtInMatches[1];
        } else {
            // Failed to match the standard '[object ClassName]'
            return toString.call(val);
        }
        if (className == 'Object') {
            // we're a user defined class or Object
            // JSON.stringify avoids problems with cycles, and is generally much
            // easier than looping through ownProperties of `val`.
            try {
                return 'Object(' + JSON.stringify(val) + ')';
            } catch (_) {
                return 'Object';
            }
        }
        // errors
        if (val instanceof Error) {
            return `${val.name}: ${val.message}\n${val.stack}`;
        }
        // TODO we could test for more things here, like `Set`s and `Map`s.
        return className;
    }
    /**
     * @returns {number}
     */
    __exports.frb_get_rust_content_hash = function() {
        const ret = wasm.frb_get_rust_content_hash();
        return ret;
    };

    /**
     * @param {number} func_id
     * @param {any} port_
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     */
    __exports.frb_pde_ffi_dispatcher_primary = function(func_id, port_, ptr_, rust_vec_len_, data_len_) {
        _assertNum(func_id);
        _assertNum(rust_vec_len_);
        _assertNum(data_len_);
        wasm.frb_pde_ffi_dispatcher_primary(func_id, port_, ptr_, rust_vec_len_, data_len_);
    };

    /**
     * @param {number} func_id
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     * @returns {any}
     */
    __exports.frb_pde_ffi_dispatcher_sync = function(func_id, ptr_, rust_vec_len_, data_len_) {
        _assertNum(func_id);
        _assertNum(rust_vec_len_);
        _assertNum(data_len_);
        const ret = wasm.frb_pde_ffi_dispatcher_sync(func_id, ptr_, rust_vec_len_, data_len_);
        return ret;
    };

    /**
     * @param {number} call_id
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     */
    __exports.dart_fn_deliver_output = function(call_id, ptr_, rust_vec_len_, data_len_) {
        _assertNum(call_id);
        _assertNum(rust_vec_len_);
        _assertNum(data_len_);
        wasm.dart_fn_deliver_output(call_id, ptr_, rust_vec_len_, data_len_);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519Signature = function(ptr) {
        _assertNum(ptr);
        wasm.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519Signature(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519Signature = function(ptr) {
        _assertNum(ptr);
        wasm.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519Signature(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPrivateKey = function(ptr) {
        _assertNum(ptr);
        wasm.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPrivateKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPrivateKey = function(ptr) {
        _assertNum(ptr);
        wasm.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPrivateKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPublicKey = function(ptr) {
        _assertNum(ptr);
        wasm.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPublicKey = function(ptr) {
        _assertNum(ptr);
        wasm.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPublicKey(ptr);
    };

    function takeFromExternrefTable0(idx) {
        const value = wasm.__wbindgen_export_2.get(idx);
        wasm.__externref_table_dealloc(idx);
        return value;
    }

    function passArrayJsValueToWasm0(array, malloc) {
        const ptr = malloc(array.length * 4, 4) >>> 0;
        const mem = getDataViewMemory0();
        for (let i = 0; i < array.length; i++) {
            mem.setUint32(ptr + 4 * i, addToExternrefTable0(array[i]), true);
        }
        WASM_VECTOR_LEN = array.length;
        return ptr;
    }
    /**
     * ## Safety
     * This function reclaims a raw pointer created by [`TransferClosure`], and therefore
     * should **only** be used in conjunction with it.
     * Furthermore, the WASM module in the worker must have been initialized with the shared
     * memory from the host JS scope.
     * @param {number} payload
     * @param {any[]} transfer
     */
    __exports.receive_transfer_closure = function(payload, transfer) {
        _assertNum(payload);
        const ptr0 = passArrayJsValueToWasm0(transfer, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.receive_transfer_closure(payload, ptr0, len0);
        if (ret[1]) {
            throw takeFromExternrefTable0(ret[0]);
        }
    };

    /**
     * @param {number} ptr
     */
    __exports.dart_opaque_drop_thread_box_persistent_handle = function(ptr) {
        _assertNum(ptr);
        wasm.dart_opaque_drop_thread_box_persistent_handle(ptr);
    };

    /**
     * @param {number} ptr
     * @returns {any}
     */
    __exports.dart_opaque_rust2dart_decode = function(ptr) {
        _assertNum(ptr);
        const ret = wasm.dart_opaque_rust2dart_decode(ptr);
        return ret;
    };

    /**
     * # Safety
     *
     * This should never be called manually.
     * @param {any} handle
     * @param {any} dart_handler_port
     * @returns {number}
     */
    __exports.dart_opaque_dart2rust_encode = function(handle, dart_handler_port) {
        const ret = wasm.dart_opaque_dart2rust_encode(handle, dart_handler_port);
        return ret >>> 0;
    };

    __exports.wasm_start_callback = function() {
        wasm.wasm_start_callback();
    };

    function __wbg_adapter_36(arg0, arg1, arg2) {
        _assertNum(arg0);
        _assertNum(arg1);
        wasm.closure126_externref_shim(arg0, arg1, arg2);
    }

    function __wbg_adapter_39(arg0, arg1, arg2) {
        _assertNum(arg0);
        _assertNum(arg1);
        wasm.closure165_externref_shim(arg0, arg1, arg2);
    }

    function __wbg_adapter_42(arg0, arg1, arg2) {
        _assertNum(arg0);
        _assertNum(arg1);
        wasm.closure162_externref_shim(arg0, arg1, arg2);
    }

    function __wbg_adapter_124(arg0, arg1, arg2, arg3) {
        _assertNum(arg0);
        _assertNum(arg1);
        wasm.closure260_externref_shim(arg0, arg1, arg2, arg3);
    }

    const WorkerPoolFinalization = (typeof FinalizationRegistry === 'undefined')
        ? { register: () => {}, unregister: () => {} }
        : new FinalizationRegistry(ptr => wasm.__wbg_workerpool_free(ptr >>> 0, 1));

    class WorkerPool {

        __destroy_into_raw() {
            const ptr = this.__wbg_ptr;
            this.__wbg_ptr = 0;
            WorkerPoolFinalization.unregister(this);
            return ptr;
        }

        free() {
            const ptr = this.__destroy_into_raw();
            wasm.__wbg_workerpool_free(ptr, 0);
        }
        /**
         * Creates a new `WorkerPool` which immediately creates `initial` workers.
         *
         * The pool created here can be used over a long period of time, and it
         * will be initially primed with `initial` workers. Currently workers are
         * never released or gc'd until the whole pool is destroyed.
         *
         * # Errors
         *
         * Returns any error that may happen while a JS web worker is created and a
         * message is sent to it.
         * @param {number} initial
         * @param {string} script_src
         */
        constructor(initial, script_src) {
            _assertNum(initial);
            const ptr0 = passStringToWasm0(script_src, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len0 = WASM_VECTOR_LEN;
            const ret = wasm.workerpool_new(initial, ptr0, len0);
            if (ret[2]) {
                throw takeFromExternrefTable0(ret[1]);
            }
            this.__wbg_ptr = ret[0] >>> 0;
            WorkerPoolFinalization.register(this, this.__wbg_ptr, this);
            return this;
        }
    }
    __exports.WorkerPool = WorkerPool;

    async function __wbg_load(module, imports) {
        if (typeof Response === 'function' && module instanceof Response) {
            if (typeof WebAssembly.instantiateStreaming === 'function') {
                try {
                    return await WebAssembly.instantiateStreaming(module, imports);

                } catch (e) {
                    if (module.headers.get('Content-Type') != 'application/wasm') {
                        console.warn("`WebAssembly.instantiateStreaming` failed because your server does not serve Wasm with `application/wasm` MIME type. Falling back to `WebAssembly.instantiate` which is slower. Original error:\n", e);

                    } else {
                        throw e;
                    }
                }
            }

            const bytes = await module.arrayBuffer();
            return await WebAssembly.instantiate(bytes, imports);

        } else {
            const instance = await WebAssembly.instantiate(module, imports);

            if (instance instanceof WebAssembly.Instance) {
                return { instance, module };

            } else {
                return instance;
            }
        }
    }

    function __wbg_get_imports() {
        const imports = {};
        imports.wbg = {};
        imports.wbg.__wbg_async_9ac6fc144c5030e2 = function() { return logError(function (arg0) {
            const ret = arg0.async;
            _assertBoolean(ret);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_buffer_61b7ce01341d7f88 = function() { return logError(function (arg0) {
            const ret = arg0.buffer;
            return ret;
        }, arguments) };
        imports.wbg.__wbg_call_500db948e69c7330 = function() { return handleError(function (arg0, arg1, arg2) {
            const ret = arg0.call(arg1, arg2);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_call_b0d8e36992d9900d = function() { return handleError(function (arg0, arg1) {
            const ret = arg0.call(arg1);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_createObjectURL_296ad2113ed20fe0 = function() { return handleError(function (arg0, arg1) {
            const ret = URL.createObjectURL(arg1);
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        }, arguments) };
        imports.wbg.__wbg_data_4ce8a82394d8b110 = function() { return logError(function (arg0) {
            const ret = arg0.data;
            return ret;
        }, arguments) };
        imports.wbg.__wbg_error_7534b8e9a36f1ab4 = function() { return logError(function (arg0, arg1) {
            let deferred0_0;
            let deferred0_1;
            try {
                deferred0_0 = arg0;
                deferred0_1 = arg1;
                console.error(getStringFromWasm0(arg0, arg1));
            } finally {
                wasm.__wbindgen_free(deferred0_0, deferred0_1, 1);
            }
        }, arguments) };
        imports.wbg.__wbg_error_7eeb6e13f7693d4b = function() { return logError(function (arg0, arg1) {
            console.error(getStringFromWasm0(arg0, arg1));
        }, arguments) };
        imports.wbg.__wbg_eval_cd0c386c3899dd07 = function() { return handleError(function (arg0, arg1) {
            const ret = eval(getStringFromWasm0(arg0, arg1));
            return ret;
        }, arguments) };
        imports.wbg.__wbg_get_bbccf8970793c087 = function() { return handleError(function (arg0, arg1) {
            const ret = Reflect.get(arg0, arg1);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_instanceof_BroadcastChannel_3b5ae13c314e67a9 = function() { return logError(function (arg0) {
            let result;
            try {
                result = arg0 instanceof BroadcastChannel;
            } catch (_) {
                result = false;
            }
            const ret = result;
            _assertBoolean(ret);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_instanceof_ErrorEvent_a42064d9628e071c = function() { return logError(function (arg0) {
            let result;
            try {
                result = arg0 instanceof ErrorEvent;
            } catch (_) {
                result = false;
            }
            const ret = result;
            _assertBoolean(ret);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_instanceof_MessageEvent_4503e23b62c66dfc = function() { return logError(function (arg0) {
            let result;
            try {
                result = arg0 instanceof MessageEvent;
            } catch (_) {
                result = false;
            }
            const ret = result;
            _assertBoolean(ret);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_length_65d1cd11729ced11 = function() { return logError(function (arg0) {
            const ret = arg0.length;
            _assertNum(ret);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_message_5d9da9f584617c9f = function() { return logError(function (arg0, arg1) {
            const ret = arg1.message;
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        }, arguments) };
        imports.wbg.__wbg_name_e6ccca67b371df34 = function() { return logError(function (arg0, arg1) {
            const ret = arg1.name;
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        }, arguments) };
        imports.wbg.__wbg_new_1bbd050bd0c8595a = function() { return handleError(function (arg0, arg1) {
            const ret = new BroadcastChannel(getStringFromWasm0(arg0, arg1));
            return ret;
        }, arguments) };
        imports.wbg.__wbg_new_254fa9eac11932ae = function() { return logError(function () {
            const ret = new Array();
            return ret;
        }, arguments) };
        imports.wbg.__wbg_new_31cb5207e607864d = function() { return logError(function (arg0) {
            const ret = new Int32Array(arg0);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_new_3d446df9155128ef = function() { return logError(function (arg0, arg1) {
            try {
                var state0 = {a: arg0, b: arg1};
                var cb0 = (arg0, arg1) => {
                    const a = state0.a;
                    state0.a = 0;
                    try {
                        return __wbg_adapter_124(a, state0.b, arg0, arg1);
                    } finally {
                        state0.a = a;
                    }
                };
                const ret = new Promise(cb0);
                return ret;
            } finally {
                state0.a = state0.b = 0;
            }
        }, arguments) };
        imports.wbg.__wbg_new_3d662e5b2b6548c5 = function() { return handleError(function (arg0, arg1) {
            const ret = new Worker(getStringFromWasm0(arg0, arg1));
            return ret;
        }, arguments) };
        imports.wbg.__wbg_new_3ff5b33b1ce712df = function() { return logError(function (arg0) {
            const ret = new Uint8Array(arg0);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_new_688846f374351c92 = function() { return logError(function () {
            const ret = new Object();
            return ret;
        }, arguments) };
        imports.wbg.__wbg_new_8a6f238a6ece86ea = function() { return logError(function () {
            const ret = new Error();
            return ret;
        }, arguments) };
        imports.wbg.__wbg_newnoargs_fd9e4bf8be2bc16d = function() { return logError(function (arg0, arg1) {
            const ret = new Function(getStringFromWasm0(arg0, arg1));
            return ret;
        }, arguments) };
        imports.wbg.__wbg_newwithblobsequenceandoptions_b590694ff46405f6 = function() { return handleError(function (arg0, arg1) {
            const ret = new Blob(arg0, arg1);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_newwithbyteoffsetandlength_ba35896968751d91 = function() { return logError(function (arg0, arg1, arg2) {
            const ret = new Uint8Array(arg0, arg1 >>> 0, arg2 >>> 0);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_of_d3331a102e573656 = function() { return logError(function (arg0, arg1, arg2) {
            const ret = Array.of(arg0, arg1, arg2);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_postMessage_19a1943702ae7f6c = function() { return handleError(function (arg0, arg1) {
            arg0.postMessage(arg1);
        }, arguments) };
        imports.wbg.__wbg_postMessage_586e33893b92051e = function() { return handleError(function (arg0, arg1, arg2) {
            arg0.postMessage(arg1, arg2);
        }, arguments) };
        imports.wbg.__wbg_postMessage_6fd166b24db78adf = function() { return handleError(function (arg0, arg1) {
            arg0.postMessage(arg1);
        }, arguments) };
        imports.wbg.__wbg_postMessage_f648f854fd6c3f80 = function() { return handleError(function (arg0, arg1) {
            arg0.postMessage(arg1);
        }, arguments) };
        imports.wbg.__wbg_push_6edad0df4b546b2c = function() { return logError(function (arg0, arg1) {
            const ret = arg0.push(arg1);
            _assertNum(ret);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_queueMicrotask_2181040e064c0dc8 = function() { return logError(function (arg0) {
            queueMicrotask(arg0);
        }, arguments) };
        imports.wbg.__wbg_queueMicrotask_ef9ac43769cbcc4f = function() { return logError(function (arg0) {
            const ret = arg0.queueMicrotask;
            return ret;
        }, arguments) };
        imports.wbg.__wbg_resolve_0bf7c44d641804f9 = function() { return logError(function (arg0) {
            const ret = Promise.resolve(arg0);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_set_23d69db4e5c66a6e = function() { return logError(function (arg0, arg1, arg2) {
            arg0.set(arg1, arg2 >>> 0);
        }, arguments) };
        imports.wbg.__wbg_setonerror_ce12d6e32c146e3d = function() { return logError(function (arg0, arg1) {
            arg0.onerror = arg1;
        }, arguments) };
        imports.wbg.__wbg_setonmessage_4596c1308611382a = function() { return logError(function (arg0, arg1) {
            arg0.onmessage = arg1;
        }, arguments) };
        imports.wbg.__wbg_settype_fd39465d237c2f36 = function() { return logError(function (arg0, arg1, arg2) {
            arg0.type = getStringFromWasm0(arg1, arg2);
        }, arguments) };
        imports.wbg.__wbg_stack_0ed75d68575b0f3c = function() { return logError(function (arg0, arg1) {
            const ret = arg1.stack;
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        }, arguments) };
        imports.wbg.__wbg_static_accessor_GLOBAL_0be7472e492ad3e3 = function() { return logError(function () {
            const ret = typeof global === 'undefined' ? null : global;
            return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
        }, arguments) };
        imports.wbg.__wbg_static_accessor_GLOBAL_THIS_1a6eb482d12c9bfb = function() { return logError(function () {
            const ret = typeof globalThis === 'undefined' ? null : globalThis;
            return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
        }, arguments) };
        imports.wbg.__wbg_static_accessor_SELF_1dc398a895c82351 = function() { return logError(function () {
            const ret = typeof self === 'undefined' ? null : self;
            return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
        }, arguments) };
        imports.wbg.__wbg_static_accessor_WINDOW_ae1c80c7eea8d64a = function() { return logError(function () {
            const ret = typeof window === 'undefined' ? null : window;
            return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
        }, arguments) };
        imports.wbg.__wbg_then_0438fad860fe38e1 = function() { return logError(function (arg0, arg1) {
            const ret = arg0.then(arg1);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_unshift_96c5b9afa55182d1 = function() { return logError(function (arg0, arg1) {
            const ret = arg0.unshift(arg1);
            _assertNum(ret);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_value_d13029fab89e1e86 = function() { return logError(function (arg0) {
            const ret = arg0.value;
            return ret;
        }, arguments) };
        imports.wbg.__wbg_waitAsync_b8546c4e21098b3f = function() { return logError(function () {
            const ret = Atomics.waitAsync;
            return ret;
        }, arguments) };
        imports.wbg.__wbg_waitAsync_fa6069d0a74f6749 = function() { return logError(function (arg0, arg1, arg2) {
            const ret = Atomics.waitAsync(arg0, arg1 >>> 0, arg2);
            return ret;
        }, arguments) };
        imports.wbg.__wbindgen_cb_drop = function(arg0) {
            const obj = arg0.original;
            if (obj.cnt-- == 1) {
                obj.a = 0;
                return true;
            }
            const ret = false;
            _assertBoolean(ret);
            return ret;
        };
        imports.wbg.__wbindgen_closure_wrapper447 = function() { return logError(function (arg0, arg1, arg2) {
            const ret = makeMutClosure(arg0, arg1, 127, __wbg_adapter_36);
            return ret;
        }, arguments) };
        imports.wbg.__wbindgen_closure_wrapper569 = function() { return logError(function (arg0, arg1, arg2) {
            const ret = makeMutClosure(arg0, arg1, 166, __wbg_adapter_39);
            return ret;
        }, arguments) };
        imports.wbg.__wbindgen_closure_wrapper570 = function() { return logError(function (arg0, arg1, arg2) {
            const ret = makeMutClosure(arg0, arg1, 163, __wbg_adapter_42);
            return ret;
        }, arguments) };
        imports.wbg.__wbindgen_debug_string = function(arg0, arg1) {
            const ret = debugString(arg1);
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        };
        imports.wbg.__wbindgen_init_externref_table = function() {
            const table = wasm.__wbindgen_export_2;
            const offset = table.grow(4);
            table.set(0, undefined);
            table.set(offset + 0, undefined);
            table.set(offset + 1, null);
            table.set(offset + 2, true);
            table.set(offset + 3, false);
            ;
        };
        imports.wbg.__wbindgen_is_falsy = function(arg0) {
            const ret = !arg0;
            _assertBoolean(ret);
            return ret;
        };
        imports.wbg.__wbindgen_is_function = function(arg0) {
            const ret = typeof(arg0) === 'function';
            _assertBoolean(ret);
            return ret;
        };
        imports.wbg.__wbindgen_is_undefined = function(arg0) {
            const ret = arg0 === undefined;
            _assertBoolean(ret);
            return ret;
        };
        imports.wbg.__wbindgen_jsval_eq = function(arg0, arg1) {
            const ret = arg0 === arg1;
            _assertBoolean(ret);
            return ret;
        };
        imports.wbg.__wbindgen_link_dca1b66dc9e85c0b = function() { return logError(function (arg0) {
            const val = `onmessage = function (ev) {
                let [ia, index, value] = ev.data;
                ia = new Int32Array(ia.buffer);
                let result = Atomics.wait(ia, index, value);
                postMessage(result);
            };
            `;
            const ret = typeof URL.createObjectURL === 'undefined' ? "data:application/javascript," + encodeURIComponent(val) : URL.createObjectURL(new Blob([val], { type: "text/javascript" }));
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        }, arguments) };
        imports.wbg.__wbindgen_memory = function() {
            const ret = wasm.memory;
            return ret;
        };
        imports.wbg.__wbindgen_module = function() {
            const ret = __wbg_init.__wbindgen_wasm_module;
            return ret;
        };
        imports.wbg.__wbindgen_number_get = function(arg0, arg1) {
            const obj = arg1;
            const ret = typeof(obj) === 'number' ? obj : undefined;
            if (!isLikeNone(ret)) {
                _assertNum(ret);
            }
            getDataViewMemory0().setFloat64(arg0 + 8 * 1, isLikeNone(ret) ? 0 : ret, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, !isLikeNone(ret), true);
        };
        imports.wbg.__wbindgen_number_new = function(arg0) {
            const ret = arg0;
            return ret;
        };
        imports.wbg.__wbindgen_rethrow = function(arg0) {
            throw arg0;
        };
        imports.wbg.__wbindgen_string_get = function(arg0, arg1) {
            const obj = arg1;
            const ret = typeof(obj) === 'string' ? obj : undefined;
            var ptr1 = isLikeNone(ret) ? 0 : passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            var len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        };
        imports.wbg.__wbindgen_string_new = function(arg0, arg1) {
            const ret = getStringFromWasm0(arg0, arg1);
            return ret;
        };
        imports.wbg.__wbindgen_throw = function(arg0, arg1) {
            throw new Error(getStringFromWasm0(arg0, arg1));
        };

        return imports;
    }

    function __wbg_init_memory(imports, memory) {
        imports.wbg.memory = memory || new WebAssembly.Memory({initial:22,maximum:16384,shared:true});
    }

    function __wbg_finalize_init(instance, module, thread_stack_size) {
        wasm = instance.exports;
        __wbg_init.__wbindgen_wasm_module = module;
        cachedDataViewMemory0 = null;
        cachedUint8ArrayMemory0 = null;

        if (typeof thread_stack_size !== 'undefined' && (typeof thread_stack_size !== 'number' || thread_stack_size === 0 || thread_stack_size % 65536 !== 0)) { throw 'invalid stack size' }
        wasm.__wbindgen_start(thread_stack_size);
        return wasm;
    }

    function initSync(module, memory) {
        if (wasm !== undefined) return wasm;

        let thread_stack_size
        if (typeof module !== 'undefined') {
            if (Object.getPrototypeOf(module) === Object.prototype) {
                ({module, memory, thread_stack_size} = module)
            } else {
                console.warn('using deprecated parameters for `initSync()`; pass a single object instead')
            }
        }

        const imports = __wbg_get_imports();

        __wbg_init_memory(imports, memory);

        if (!(module instanceof WebAssembly.Module)) {
            module = new WebAssembly.Module(module);
        }

        const instance = new WebAssembly.Instance(module, imports);

        return __wbg_finalize_init(instance, module, thread_stack_size);
    }

    async function __wbg_init(module_or_path, memory) {
        if (wasm !== undefined) return wasm;

        let thread_stack_size
        if (typeof module_or_path !== 'undefined') {
            if (Object.getPrototypeOf(module_or_path) === Object.prototype) {
                ({module_or_path, memory, thread_stack_size} = module_or_path)
            } else {
                console.warn('using deprecated parameters for the initialization function; pass a single object instead')
            }
        }

        if (typeof module_or_path === 'undefined' && typeof script_src !== 'undefined') {
            module_or_path = script_src.replace(/\.js$/, '_bg.wasm');
        }
        const imports = __wbg_get_imports();

        if (typeof module_or_path === 'string' || (typeof Request === 'function' && module_or_path instanceof Request) || (typeof URL === 'function' && module_or_path instanceof URL)) {
            module_or_path = fetch(module_or_path);
        }

        __wbg_init_memory(imports, memory);

        const { instance, module } = await __wbg_load(await module_or_path, imports);

        return __wbg_finalize_init(instance, module, thread_stack_size);
    }

    wasm_bindgen = Object.assign(__wbg_init, { initSync }, __exports);

})();
