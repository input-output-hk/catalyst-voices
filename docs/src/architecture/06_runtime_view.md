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

## User Authentication and Session Management

This scenario shows how a user authenticates and establishes a session.

```mermaid
sequenceDiagram
  participant UI as Login Page
  participant BLOC as SessionCubit
  participant SERVICE as AuthService
  participant REPO as Auth Repository
  participant WASM as Key Derivation (Rust WASM)
  participant API as Gateway API
  participant LDB as Local DB
  participant SECURE as Secure Storage

  UI->>BLOC: Login Event (mnemonic)
  BLOC->>SERVICE: Authenticate request
  SERVICE->>WASM: Derive keys from mnemonic
  WASM-->>SERVICE: Derived keys
  SERVICE->>REPO: Authenticate with keys
  REPO->>API: GET /cardano/rbac/registrations
  API-->>REPO: RBAC registration data
  REPO->>LDB: Cache registration data
  REPO->>SECURE: Store encrypted keys
  REPO-->>SERVICE: Authentication result
  SERVICE->>SERVICE: Update UserObserver
  SERVICE-->>BLOC: Authentication result
  BLOC->>BLOC: Update SessionState
  BLOC-->>UI: Authenticated state
  UI->>UI: Navigate to workspace
```

Notable aspects:

* Keys are derived client-side using Rust WASM for security
* RBAC registration data is cached locally for offline access
* Sensitive keys stored in secure storage (encrypted)
* Session state managed reactively via BLoC
* UserObserver tracks user state changes for cross-feature communication

## Proposal Creation and Submission

This scenario shows how a user creates and submits a proposal.

```mermaid
sequenceDiagram
  participant UI as Proposal Builder Page
  participant BLOC as ProposalBuilderBloc
  participant VM as ProposalViewModel
  participant SERVICE as ProposalService
  participant REPO as Document Repository
  participant COSE as COSE Library
  participant COMP as Compression (Rust WASM)
  participant API as Gateway API
  participant LDB as Local DB

  UI->>BLOC: Start Proposal Event
  BLOC->>VM: Initialize form state
  VM-->>UI: Form fields

  loop User Input
    UI->>BLOC: Update Proposal Event
    BLOC->>VM: Update form state
    VM-->>UI: Updated UI
  end

  UI->>BLOC: Submit Proposal Event
  BLOC->>VM: Validate form
  VM-->>BLOC: Validation result

  alt Valid
    BLOC->>SERVICE: Create proposal document
    SERVICE->>REPO: Create proposal document
    REPO->>COSE: Sign document
    COSE->>COMP: Compress document
    COMP-->>REPO: Compressed CBOR
    REPO->>API: PUT /v1/document
    API-->>REPO: Document ID
    REPO->>LDB: Cache document locally (BlobColumn)
    REPO-->>SERVICE: Success
    SERVICE->>SERVICE: Update ActiveCampaignObserver
    SERVICE-->>BLOC: Success
    BLOC->>BLOC: Emit signal (PublishedProposalBuilderSignal)
    BLOC-->>UI: Signal emitted
    UI->>UI: Handle signal (navigate to proposal page)
  else Invalid
    BLOC-->>UI: Show validation errors
  end
```

Notable aspects:

* Form state managed via ViewModel for separation of concerns
* Document signing and compression happen client-side using Rust WASM
* Documents cached locally in BlobColumn before submission
* Optimistic updates provide immediate feedback
* Signals used for user event information (navigation), not direct BLoC communication
* ActiveCampaignObserver updated via service layer

## Voting Flow

This scenario shows how a user casts a vote and submits the transaction.

```mermaid
sequenceDiagram
  participant UI as Voting Page
  participant BLOC as VotingCubit
  participant SERVICE as VotingService
  participant PROPOSAL as ProposalService
  participant BALLOT as VotingBallotBuilder
  participant WASM as Key Derivation (Rust WASM)
  participant COSE as COSE Library
  participant API as Gateway API
  participant LDB as Local DB

  UI->>BLOC: Cast Vote Event
  BLOC->>SERVICE: Build voting ballot
  SERVICE->>PROPOSAL: Get proposal data
  PROPOSAL-->>SERVICE: Proposal details
  SERVICE->>BALLOT: Build ballot
  BALLOT->>WASM: Derive signing keys
  WASM-->>BALLOT: Keys
  BALLOT->>COSE: Sign ballot as COSE document
  COSE-->>BALLOT: Signed ballot
  BALLOT-->>SERVICE: Complete ballot
  SERVICE->>API: PUT /v1/document (vote document)
  API-->>SERVICE: Vote document ID
  SERVICE->>LDB: Cache vote locally
  SERVICE->>SERVICE: Update CastedVotesObserver
  SERVICE-->>BLOC: Vote cast successfully
  BLOC->>BLOC: Emit signal (VoteCastedSignal)
  BLOC-->>UI: Signal emitted
  UI->>UI: Handle signal (show success snackbar)
```

Notable aspects:

* Voting ballot built using VotingBallotBuilder
* Keys derived using Rust WASM
* Vote signed as COSE document client-side
* CastedVotesObserver tracks vote casting for cross-feature communication
* Signals used for user feedback (snackbars), handled in pages

## Document Viewing and Editing Flow

This scenario shows how documents are viewed and edited with version management.

```mermaid
sequenceDiagram
  participant UI as Document Page
  participant BLOC as ProposalCubit
  participant SERVICE as ProposalService
  participant REPO as Document Repository
  participant LDB as Local DB
  participant API as Gateway API
  participant SYNC as Sync Service

  UI->>BLOC: Load Document Event
  BLOC->>SERVICE: Get proposal
  SERVICE->>REPO: Fetch document
  REPO->>LDB: Check local cache
  LDB-->>REPO: Cached document (if available)
  REPO->>API: GET /v1/document/:id (if needed)
  API-->>REPO: Document data
  REPO->>LDB: Update cache
  REPO-->>SERVICE: Document data
  SERVICE-->>BLOC: Proposal data
  BLOC-->>UI: Display document

  Note over UI,SYNC: User edits document
  UI->>BLOC: Update Document Event
  BLOC->>SERVICE: Update draft
  SERVICE->>REPO: Save draft locally
  REPO->>LDB: Store draft (BlobColumn)
  REPO-->>SERVICE: Draft saved
  SERVICE-->>BLOC: Draft updated
  BLOC-->>UI: UI updated

  Note over UI,SYNC: Background sync
  SYNC->>REPO: Check for updates
  REPO->>API: Fetch latest versions
  API-->>REPO: Updated documents
  REPO->>LDB: Update cache
  REPO->>SERVICE: Notify of updates
  SERVICE->>BLOC: Emit signal (DocumentUpdatedSignal)
  BLOC-->>UI: Signal emitted
  UI->>UI: Handle signal (show update notification)
```

Notable aspects:

* Local database checked first for responsiveness
* Documents stored in BlobColumn with JSONB converters
* Background sync keeps data fresh
* Version management handled through document references
* Signals notify UI of updates

## Workspace Management Flow

This scenario shows how the workspace manages user proposals and drafts.

```mermaid
sequenceDiagram
  participant UI as Workspace Page
  participant BLOC as WorkspaceBloc
  participant SERVICE as ProposalService
  participant REPO as Proposal Repository
  participant LDB as Local DB
  participant OBSERVER as ActiveCampaignObserver

  UI->>BLOC: Watch User Proposals Event
  BLOC->>SERVICE: Watch user proposals
  SERVICE->>OBSERVER: Get active campaign
  OBSERVER-->>SERVICE: Active campaign
  SERVICE->>REPO: Watch proposals stream
  REPO->>LDB: Query local proposals
  LDB-->>REPO: Local proposals
  REPO->>REPO: Merge local and remote proposals
  REPO-->>SERVICE: Merged proposals stream
  SERVICE-->>BLOC: Proposals stream
  BLOC-->>UI: Display proposals

  Note over UI,OBSERVER: User deletes draft
  UI->>BLOC: Delete Draft Event
  BLOC->>SERVICE: Delete draft
  SERVICE->>REPO: Delete from local storage
  REPO->>LDB: Remove draft
  REPO-->>SERVICE: Draft deleted
  SERVICE-->>BLOC: Success
  BLOC->>BLOC: Emit signal (DeletedDraftWorkspaceSignal)
  BLOC-->>UI: Signal emitted
  UI->>UI: Handle signal (show success snackbar)
```

Notable aspects:

* ProposalService merges local and remote proposals into unified stream
* ActiveCampaignObserver provides campaign context
* Local drafts managed separately from published proposals
* Signals used for user feedback (snackbars)

## Offline-First Data Synchronization

This scenario shows how the app handles offline operations and syncs when online.

```mermaid
sequenceDiagram
  participant UI as Any Page
  participant BLOC as Feature BLoC
  participant SERVICE as Feature Service
  participant REPO as Repository
  participant SYNC as Sync Manager
  participant LDB as Local DB
  participant API as Gateway API

  Note over UI,LDB: Online Mode
  UI->>BLOC: Request data
  BLOC->>SERVICE: Fetch data
  SERVICE->>REPO: Fetch data
  REPO->>LDB: Check local cache
  LDB-->>REPO: Cached data (if available)
  REPO->>API: Fetch fresh data
  API-->>REPO: Fresh data
  REPO->>LDB: Update cache (BlobColumn)
  REPO-->>SERVICE: Data
  SERVICE-->>BLOC: Data
  BLOC-->>UI: Update UI

  Note over UI,LDB: Offline Mode
  UI->>BLOC: Request data
  BLOC->>SERVICE: Fetch data
  SERVICE->>REPO: Fetch data
  REPO->>LDB: Read from cache
  LDB-->>REPO: Cached data
  REPO-->>SERVICE: Data
  SERVICE-->>BLOC: Data
  BLOC-->>UI: Update UI

  Note over UI,LDB: Background Sync
  loop Periodic Sync
    SYNC->>LDB: Check sync status
    SYNC->>API: Fetch updates since last sync
    API-->>SYNC: Changes
    SYNC->>LDB: Apply updates (complex SQLite queries)
    SYNC->>SERVICE: Notify of updates (if UI active)
    SERVICE->>BLOC: Emit signal (if needed)
  end
```

Notable aspects:

* Local database always checked first for responsiveness
* Background sync keeps data fresh when online
* Complex SQLite queries with JSONB functions for document filtering
* Conflict resolution handles concurrent modifications
* UI updates reactively via BLoC streams
* Documents stored in BlobColumn with type converters

## Error Handling and Recovery Flow

This scenario shows how errors are handled and recovered from.

```mermaid
sequenceDiagram
  participant UI as Page
  participant BLOC as Feature BLoC
  participant SERVICE as Feature Service
  participant REPO as Repository
  participant API as Gateway API
  participant LDB as Local DB

  UI->>BLOC: User Action Event
  BLOC->>SERVICE: Perform operation
  SERVICE->>REPO: Execute operation
  REPO->>API: API request
  API-->>REPO: Error response

  alt Network Error
    REPO->>LDB: Fallback to local cache
    LDB-->>REPO: Cached data
    REPO-->>SERVICE: Cached data (with error flag)
    SERVICE-->>BLOC: Error state
    BLOC->>BLOC: Emit error state
    BLOC-->>UI: Display error with retry option
    UI->>BLOC: Retry Event
    BLOC->>SERVICE: Retry operation
  else Validation Error
    REPO-->>SERVICE: Validation error
    SERVICE-->>BLOC: Error state with details
    BLOC-->>UI: Display validation errors
  else Unknown Error
    REPO-->>SERVICE: Error
    SERVICE-->>BLOC: Error state
    BLOC->>BLOC: Emit signal (ErrorSignal)
    BLOC-->>UI: Signal emitted
    UI->>UI: Handle signal (show error snackbar)
  end
```

Notable aspects:

* Error states managed in BLoC
* Local cache provides fallback for network errors
* Validation errors provide actionable feedback
* Signals used for user-facing error notifications
* Error recovery with retry mechanisms
