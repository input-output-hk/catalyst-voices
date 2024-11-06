#!/bin/sh
# Builds and rust the example for the catalyst_key_derivation.

flutter_rust_bridge_codegen generate --default-external-library-loader-web-prefix=/assets/packages/catalyst_key_derivation/assets/js/
flutter_rust_bridge_codegen build-web
mkdir -p assets/js
mv web/pkg/catalyst_key_derivation_bg.wasm assets/js/
mv web/pkg/catalyst_key_derivation.js assets/js/
mv web/pkg/package.json assets/js/
cd example
flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp -d chrome