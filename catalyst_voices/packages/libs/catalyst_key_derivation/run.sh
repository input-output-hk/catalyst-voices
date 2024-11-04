#!/bin/sh
# Builds and rust the example for the catalyst_key_derivation.

flutter_rust_bridge_codegen generate --default-external-library-loader-web-prefix=/assets/packages/catalyst_key_derivation/web/pkg/
flutter_rust_bridge_codegen build-web
cd example
flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp -d chrome