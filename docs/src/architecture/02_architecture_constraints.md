---
icon: material/handcuffs
---

# Architecture Constraints

<!-- See: https://docs.arc42.org/section-2/ -->

Technical constraints:

* Backend implemented in Rust using `poem` and `poem_openapi` for HTTP APIs.
* Event data stored in PostgreSQL with schema in the Event DB
  [catalyst-gateway/event-db](https://github.com/input-output-hk/catalyst-voices/tree/main/catalyst-gateway/event-db).
* Chain indexing and caches backed by Scylla clusters, which are Cassandra compatible, for persistent and volatile data.
* Identifiers use UUIDv7 where applicable for time ordered IDs.
* Cryptography uses Ed25519 keys and COSE Sign over CBOR payloads for signed documents.
* Document templates and references are versioned and linked by `[id, ver]` pairs.

Client constraints:

* Frontend implemented in Flutter and Dart for Web, Android, and iOS.
* Local persistence via Drift (SQLite), with `sqlite3.wasm` on Web.
* Rust functionality exposed to Flutter via WASM and bridge libraries for key derivation and compression.
* One sentence per line documentation practice with 132 character maximum line length.

Standards and interoperability:

* Voter registrations use CIP-509 for all new registrations and flows.
* Legacy voter registration tracking uses CIP-36 for historical compatibility only.
* Role based access control is linked to on-chain registrations per CIP-509.
* Hierarchical key derivation follows a Catalyst specific derivation path aligned with CIP-1852 principles.

Operational constraints:

* Builds orchestrated with Earthly for reproducible artifacts and code generation.
* Containerized deployment for gateway and Postgres with Prometheus compatible metrics endpoints.
* Strict CORS and TLS for public endpoints with API rate limiting where needed.
* Observability and panic catching middleware included in the HTTP stack.

Legal and compliance:

* Personal data must respect local privacy laws and minimize retention.
* Accessibility targets WCAG compliance for client UIs.
* Public audit trails for voting and proposals without exposing private keys or sensitive data.
