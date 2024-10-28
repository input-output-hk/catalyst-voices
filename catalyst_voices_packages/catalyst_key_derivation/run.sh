#!/bin/bash

flutter_rust_bridge_codegen generate
flutter_rust_bridge_codegen build-web
cd example
rm -fR web/pkg
cp -R ../web/pkg web/
flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp -d chrome