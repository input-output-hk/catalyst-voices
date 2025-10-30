---
icon: material/run-fast
---

# Runtime View

<!-- See: https://docs.arc42.org/section-6/ -->

## RBAC Registration Surfacing

This scenario shows how an on-chain RBAC registration becomes available to clients.

```mermaid
sequenceDiagram
  participant CN as Cardano Network
  participant CF as Chain Follower
  participant CC as Scylla Caches
  participant API as Gateway API
  participant UI as Client

  CF->>CN: Sync via Cardano N2N for new blocks and transactions.
  CF->>CC: Normalize RBAC registrations and update caches.
  UI->>API: GET /cardano/rbac/registrations.
  API->>CC: Query caches for requester filters.
  CC-->>API: Registration chain with metadata.
  API-->>UI: JSON response with pagination and freshness headers.
```

Notable aspects:

* Reads are eventually consistent with chain data freshness reported via metrics and headers.
* Cache updates are idempotent and retried to avoid gaps when data is stale.

## Proposal Submission

This scenario shows how a user submits a new versioned proposal document.

```mermaid
sequenceDiagram
  participant UI as Client
  participant CR as Crypto (WASM)
  participant API as Gateway API
  participant DS as Document Service
  participant DB as Event DB

  UI->>CR: Derive key and sign proposal COSE over CBOR.
  UI->>API: PUT /v1/document with CBOR body and RBAC token.
  API->>DS: Validate authorization and signature.
  DS->>DB: Write document, update latest pointers, and indexes.
  DB-->>DS: Persisted identifiers and version metadata.
  DS-->>API: Success or structured validation error.
  API-->>UI: 200 OK with idempotent confirmation.
```

Notable aspects:

* The operation is idempotent to avoid duplicate writes across retries.
* Validation errors include actionable fields to guide user correction.

## Voting and Confirmation

This scenario shows a user casting a vote and receiving confirmation.

```mermaid
sequenceDiagram
  participant UI as Client
  participant CR as Crypto (WASM)
  participant API as Gateway API
  participant DS as Document Service
  participant DB as Event DB

  UI->>API: GET voter power and eligibility via cardano endpoints.
  UI->>CR: Sign vote envelope as a COSE document.
  UI->>API: PUT /v1/document with vote document.
  API->>DS: Validate and persist vote record.
  DS->>DB: Append version and update vote indexes.
  API-->>UI: Acknowledge accepted vote with stable identifiers.
```

Notable aspects:

* Vote documents are versioned and auditable through indexes without exposing secret material.
* Confirmation proceeds after server side checks on event timing and role permissions.
