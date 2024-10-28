#!/bin/bash

flutter_rust_bridge_codegen generate
flutter_rust_bridge_codegen build-web
cd example
flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp -d chrome