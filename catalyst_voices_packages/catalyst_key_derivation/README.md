# catalyst_key_derivation

To run the project:
1. cd catalyst_key_derivation
2. flutter_rust_bridge_codegen generate
3. flutter_rust_bridge_codegen build-web
4. cp -rf ./web/pkg ./example/web/
5. cd example
6. flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp -d chrome