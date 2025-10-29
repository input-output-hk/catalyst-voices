---
    title: 0013 Signed Documents with COSE over CBOR
    adr:
        author: Assistant
        created: 29-Oct-2025
        status: accepted
    tags:
        - security
        - cbor
        - cose
        - ed25519
---

## Context

User generated content like proposals, comments, and votes must be integrity protected and auditable.
The envelope must support versioning, references, and verification independent of transport.

## Assumptions

* Clients can sign messages locally and send binary payloads over HTTPS.
* Backends can validate signatures and enforce authorization policies.

## Decision

Use COSE_Sign over CBOR payloads signed with Ed25519 for all signed documents.
This enables future extension to multi-signatures that COSE_Sign1 precludes.
Use `[id, ver]` references within headers to link documents and templates.

## Rationale

COSE and CBOR are compact, widely supported, and language agnostic.
Ed25519 provides fast and secure signatures suitable for mobile and web.

## Implementation Guidelines

* Enforce protected headers including `kid`, `alg`, `type`, and `template`.
* Validate signatures and authorization on the gateway before persistence.
* Keep PUT semantics idempotent based on content and identifiers.

## Risks

Binary payloads complicate debugging compared to JSON only APIs.
Client side key handling mistakes can lead to user lockouts.

## Consequences

Auditable, tamper evident records independent of transport.
Slightly higher complexity in client libraries and tooling.

## More Information

* [COSE (RFC 9052)](https://www.rfc-editor.org/rfc/rfc9052)
* [CBOR (RFC 8949)](https://www.rfc-editor.org/rfc/rfc8949)
