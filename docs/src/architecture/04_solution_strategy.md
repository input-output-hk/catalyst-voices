---
icon: material/strategy
---

# Solution Strategy

<!-- See: https://docs.arc42.org/section-4/ -->

Guiding principles:

* Favor cryptographic integrity and verifiability for all user generated content.
* Decouple client UX from chain latency using off-chain signed documents and server side validation.
* Derive client keys deterministically from user seed material with a Catalyst specific path.
* Use on-chain registrations only for roles and voting power to minimize on-chain dependencies.

Key decisions:

* Backend in Rust with `poem` and `poem_openapi` to provide typed APIs and OpenAPI artifacts.
* PostgreSQL as the event system of record with versioned documents and templates.
* Scylla, a Cassandra compatible database, for scalable chain indexing and caches used by RBAC and stake queries.
* COSE over CBOR as the signed document container with Ed25519 signatures.
* UUIDv7 for sortable, globally unique document and version IDs.
* Flutter for cross-platform clients with Drift for local persistence and offline resilience.
* WASM based Rust libraries for compression and key derivation to keep a single implementation.

Quality goal alignment:

* Usability via fast local reads, progressive loading, and simple flows for new users.
* Security via explicit signing, deterministic key management, and server side checks.
* Reliability via idempotent PUT semantics, content addressed references, and metrics.
* Scalability via stateless APIs, pagination, and dedicated index storage.
