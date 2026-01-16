# Flutter Rust Bridge release mode performance improvements

This document describes the performance gains after enabling the release mode in Flutter Rust Bridge.

## Migration

When compiling flutter rust bridge code in CI add the `--RELEASE=true` flag:

```sh
DO flutter_rust_bridge+CODE_GENERATOR_WEB --WASM_MODULE_NAME="compression_wasm_bindgen" --RELEASE_MODE=true
```

## Documents indexing

Document indexing tests with large quantities of documents (28k) show document sync time has not changed.
The release mode did not bring any noticeable performance gains.
The sync times before and after the migration are within the measurement error.

Compile Flutter Rust Bridge `--RELEASE_MODE=true/false`:

```sh
DO flutter_rust_bridge+CODE_GENERATOR_WEB --WASM_MODULE_NAME="compression_wasm_bindgen" --RELEASE_MODE=true
```

Benchmark script:

```sh
flutter run --target=lib/configs/main_web.dart \
--device-id=chrome \
--profile \
--wasm \
--dart-define=ENV_NAME=dev \
--dart-define=STRESS_TEST=true \
--dart-define=STRESS_TEST_PROPOSAL_INDEX_COUNT=4000 \
--dart-define=STRESS_TEST_DECOMPRESSED=false \
--dart-define=STRESS_TEST_CLEAR_DB=true \
--web-port=5554 \
--web-header=Cross-Origin-Opener-Policy=same-origin \
--web-header=Cross-Origin-Embedder-Policy=require-corp
```

| Mode | Sync time |
| ------- | ------- |
| DEBUG (`--RELEASE_MODE=false`) | ~31.86s |
| RELEASE (`--RELEASE_MODE=true`) | ~31.71s |

## Binary size reduction

The release mode appears to have reduced the binary size of the compiled package which results
in faster application loading and lower network data usage for the end users.

| Package | Debug size | Release size | Reduction (%) |
| ------- | ------- | ---------- | -------- |
| catalyst_compression | 2448 KB | 2002 KB | -18.2% |
| catalyst_key_derivation | 998 KB | 607 KB | -39.2% |

## Notes

* All tests were executed on a Mac Studio with M1 max and 64 GB of RAM.
* All tests were performed on the chrome browser.
