---
    title: 0016 WASM-based Rust Libraries in Client
    adr:
        author: Assistant
        created: 29-Oct-2025
        status: accepted
    tags:
        - wasm
        - rust
        - flutter_rust_bridge
        - key-derivation
        - compression
---

## Context

Key derivation and compression should be implemented once and reused across platforms.
Relying on a single Rust codebase compiled to WASM reduces duplication and drift.

## Assumptions

* Flutter can interop with Rust via `flutter_rust_bridge` and WASM for Web.
* Performance is sufficient for client side operations.

## Decision

Adopt WASM based Rust libraries for key derivation and compression exposed to Flutter via `flutter_rust_bridge`.
Ship platform appropriate artifacts and loaders, including web worker initialization for WASM.

## Rationale

Single implementation ensures consistent behavior and security properties.
Rust offers strong safety guarantees and good performance for cryptographic workloads.

## Implementation Guidelines

* Provide JS loaders that initialize WASM with correct MIME types and worker setup.
* Validate outputs with shared test vectors across platforms.
* Version and package artifacts for reproducible builds.

## Risks

WASM hosting requirements can be tricky on some environments.
Bridge layers add build complexity and require CI coverage.

## Consequences

Consistent cryptographic and compression behavior across Web and Mobile.
Slightly more complex build and packaging steps.

## More Information

* [flutter_rust_bridge](https://fzyzcjy.github.io/flutter_rust_bridge/)
