---
icon: material/format-list-group-plus
---

# Glossary

<!-- See: https://docs.arc42.org/section-12/ -->

| Term | Definition |
| --- | --- |
| Catalyst Voices | Client applications and supporting code for Catalyst proposal and voting. |
| Catalyst Gateway | Rust backend service providing APIs, validation, and data access. |
| Event | A time bounded Catalyst funding round or activity. |
| Brand | An organization or initiative hosting campaigns. |
| Campaign | A specific funding initiative within a brand. |
| Category | A grouping for proposals within a campaign. |
| Space | A stage for proposals such as discovery or voting. |
| Proposal | A user submitted application for funding. |
| Template | A schema defining required structure for documents. |
| Signed Document | A COSE_Sign CBOR document with Ed25519 signature. |
| Document Version | A specific immutable version of a document. |
| UUIDv7 | Time ordered UUID variant used for document and version identifiers. |
| ULID | Universally Unique Lexicographically Sortable Identifier used in headers. |
| RBAC | Role Based Access Control linking permissions to on-chain registrations. |
| CIP-36 | Legacy voter registration format used for historical compatibility. |
| CIP-509 | Primary specification for new voter registrations and RBAC registration in Catalyst. |
| dRep | A Catalyst delegate registered via CIP-509, using signed documents for nomination and delegation. |
| Stake Address | Cardano address representing staking rights and voting power. |
| Drift | A reactive database layer for SQLite used by Flutter. |
| Scylla | A distributed, Cassandra compatible database used for chain indexing and caches. |
| PostgreSQL | Relational database used for event data and documents. |
| COSE | CBOR Object Signing and Encryption container for signatures. |
| CBOR | Concise Binary Object Representation used for document payloads. |
| Mithril | Snapshot service used to verify stake data from the Cardano network. |
| OpenAPI | Interface description used to generate client repositories. |
| N2N | Cardano Node-to-Node protocol for peer networking and transaction submission. |
