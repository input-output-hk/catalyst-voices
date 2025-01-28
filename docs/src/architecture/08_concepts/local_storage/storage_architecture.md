# **Local Storage Architecture Specification - Fund 14 Requirements Focus**

Version: 0.1 (Draft) January 2025

---
[TOC]

## **1 Summary**

This document defines the architecture for implementing a cross-platform local storage solution for Catalyst with specific focus on
the requirements for Fund 14 The primary objectives include managing JSON documents, supporting UI updates, ensuring data security,
managing local draft document creation and laying a foundation for scalable and future-proof storage practices.

The solution integrates SQLite with JSON support, encryption for sensitive draft data, and Drift for database management and
reactive streams.

## **2 Requirements & Constraints**

### **2.1 Functional Requirements**

* **Cross-Platform Local Storage**

  * Must support Web, iOS, Android, macOS, Linux, and Windows within a single Flutter codebase.

* **JSON Document Storage & Querying**

  * Utilize SQLite’s JSON1/JSONB functions for efficient querying of JSON-structured documents.

* **UUIDv7-Based Identification**

  * Enforce time-ordered identifiers for both documents and version management.

* **Secure Draft Storage**

  * Store drafts with session-bound encryption using deterministic key generation for future sync capabilites.

* **External Document API Integration**

  * Retrieve, index, and post documents to Catalyst backend API however consideration is given to future implementations where
multiple storage options are available.

* **Reactive UI Updates**

  * Rely on Drift ORM streams to automatically update the UI when local data changes.

* **Offline Access & Caching**

  * Provide offline read/write capabilities and cache documents/metadata locally.

* **Document Versioning & Metadata Indexing**

  * Track multiple versions of a document and maintain indexed metadata for fast lookups.

### **2.2 Non-Functional Requirements**

* **Performance**

  * Ensure fast read/write operations with indexing for large datasets, local caching of documents is required to avoid requests
to the backend every time a new document is required.

  * Minimize overhead when encrypting or decrypting data, encryption will only be applied to data which is not already available
in the public domain or has not been submitted by the owner.

* **Scalability**

  * Design schema and data flows to accommodate future data models, addition of indexes and additional metadata will be enabled
with out significant re-work.

* **Security & Data Integrity**

  * Enforce encryption at rest for sensitive drafts.

* **Maintainability**

  * Use a service/repository pattern and dependency injection (DI) for clearer separation of concerns, follow best practices of
clean separation of concerns when defining the data layer implementation.

  * Allow future enhancements (e.g., advanced sync logic) without redefining core elements of the local storage.

### **2.3 Constraints & Assumptions**

* **SQLite Version Requirement**

  * Requires SQLite 3.38.0+ for JSONB support (or 3.45.0+ for advanced JSON functions).

* **Technology Stack**

  * Drift ORM is used for type-safe queries, reactive streams, and schema migrations.

* **Out of Scope**

  * No built-in device synchronization or complex conflict resolution in this phase.

  * No advanced collaboration features (e.g., CRDTs) are required at this time.

* **Implementation Scope**

  * This phase covers only the architecture proposal and high-level design; no direct code implementation.

* **Existing Flutter Architecture Integration**

  * Must integrate seamlessly with the current Flutter codebase and follow established design patterns.

## **3 System Overview**

### **3.1 Key Features**

* **Document Storage**

  * JSON documents stored in SQLite with partial metadata extraction for indexing.

  * UUIDv7 ensures time-based ordering for documents and version tracking.

  * Support for secure storage of draft documents with version management.

* **Security**

  * Session-bound encryption for drafts using deterministic key derivation for both encryption and decryption.

* **Query Performance**

  * Indexed JSON fields and reactive UI updates via Drift streams.

* **Caching**

  * Local caching of frequently accessed data and metadata, supporting offline reads and writes.

### **3.2 Core Components**

* **Data Layer**

  * Tables: `documents`, `drafts`, `metadata`.

  * Support for storing UUIDv7 as INT8 pairs (recommended), BLOB, or TEXT.

* **Service Layer**

  * Encryption service for draft security.

  * Session management for key derivation, encryption, and user locking.

  * API management for document index retrieval and document actions.

* **UI Layer**

  * Drift ORM for type-safe queries and reactive streams.

  * Automatic UI updates when data changes (e.g., proposals, comments).

### **3.3 System Context and Component Relationship**

#### *System Context Diagram*

```mermaid
graph TD

User[User] -->|Enters Mnemonic| App[Flutter Application]
App -->|Pulls Documents| API[Document API]
App -->|Fetches Index Metadata| IndexService[Index API]
App -->|Stores Locally| SQLite[SQLite Database]
```

#### *Component Relationships*

```mermaid
graph TD
subgraph Flutter Application
UI[UI Layer] -->|Streams| Service[Service Layer]
Service --> Repository[Repository Layer]
Repository --> SQLite[SQLite Database]
end
subgraph External Systems
API[Document API] --> Repository
IndexService[Index API] --> Repository
end
```

### **3.4 Component Overview**

#### 3.4.1 High-Level System Separation

* **Data Layer**:

  * Tables: `documents`, `drafts`, `metadata`.

* **Service Layer**:

  * Repository pattern for database operations.

  * Dependency injection for modularity.

* **UI Layer**:

  * Reactive updates via Drift `Stream` integration.

#### 3.4.2 Data Storage Tables

* **Metadata Table**:

  * Stores extracted fields for querying.

  * Enables UI elements like counts and categories.

  * Updates via index api frequently.

* **Drafts Table**:

  * Stores encrypted drafts for session-specific access.

* **Documents Table**:

  * Stores the raw JSON documents pulled from the API.

## **4 Technology Evaluation**

### 4.1 Evaluation Criteria

* Compatibility with web, mobile, and desktop platforms

* Ease of integration with Flutter

* Performance metrics (read/write speed, indexing)

* Community support and long-term viability

* Potential for encryption & security features

### 4.2 Comparative Analysis of Storage Solutions

| **Criteria** | **SQLite + Drift** | **Hive** | **Sembast** | **ObjectBox** | **Floor** |
| ---------------------- | --------------------------- | ---------------- | ---------------- | ------------- | ---------------- |
| **JSON Support** | ✅ Native (JSON1/JSONB) | ❌ Manual parsing | ✅ Limited | ❌ No | ❌ Manual parsing |
| **Cross-Platform** | ✅ All targets | ✅ All targets | ✅ All targets | ✅ All targets | ✅ All targets |
| **Query Flexibility** | ✅ SQL + JSON Path | ❌ Key-based | ✅ Basic indexes | ❌ Limited | ✅ SQL (limited) |
| **Reactive Streams** | ✅ Drift `.watch()` | ✅ | ✅ | ✅ | ❌ |
| **Encryption** | ✅ External libraries (Database level) | ✅ Built-in | ❌ External only | ✅ Built-in | ❌ External only |
| **Scalability** | ✅ Proven at scale | ❌ Small datasets | ❌ Small datasets | ✅ High perf. | ❌ Moderate |

**Decision**: SQLite with Drift is selected due to its:

* **JSON1/JSONB Support**: Critical for querying dynamic document fields without rigid schemas.

* **Cross-Platform**: SQLite works seamlessly with Drift on all Flutter targets, including Web.

* **Reactive UI**: Drift streams enable real-time updates (e.g., `Stream<List<Document>>`).

* **Future-Proof**: Aligns with eventual IPFS integration by separating storage and indexing layers.

## **5 Database Design**

### **5.1 ER Diagram**

```mermaid

erDiagram

Documents {

Int idHi

Int idLo

Int verIdHi

Int verIdLo

Text documentType

Text content

Int createdAt

Text metadata

%% Primary Key: (idHi, idLo, verIdHi, verIdLo)

%% Index: idx_unique_ver_id UNIQUE (verIdHi, verIdLo)

}



DocumentMetadata {

Int verIdHi

Int verIdLo

Text fieldKey

Text fieldValue

%% Primary Key: (verIdHi, verIdLo, fieldKey)

%% Index: idx_doc_metadata_key_value (fieldKey, fieldValue)

}



Drafts {

Int idHi

Int idLo

Int verIdHi

Int verIdLo

Text type

Text encryptedContent

Text sessionId

Int push

Text title

%% Primary Key: (idHi, idLo, verIdHi, verIdLo)

%% Index: idx_draft_type (type)

%% Index: idx_draft_sessionid (sessionId)

}



%% Relationships

Documents ||--o| DocumentMetadata : "verIdHi, verIdLo (FK)"

Documents ||--o| Drafts : "idHi, idLo, verIdHi, verIdLo (FK)"



```

#### **5.1.1 `Documents` Table**

This table stores a record of each document (including its content and related metadata).

Each row represents a specific version of a document.

* **Primary Key (Composite):** `(idHi, idLo, verIdHi, verIdLo)`

  * These pairs (`idHi`, `idLo`) and (`verIdHi`, `verIdLo`) together uniquely identify a specific document version.

* **Fields:**

  * `documentType` (Text): Indicates the high-level type or category of the document defined by Catalyst.

  * `content` (Text): The main JSON or raw text of the document itself.

  * `createdAt` (Int): Timestamp or epoch to record when this document version was created.

  * `metadata` (Text): Inline metadata (often JSON) that may be needed alongside the main content.

* **Indexes:**

  * `idx_unique_ver_id` (UNIQUE on `verIdHi, verIdLo`): Ensures the version ID pair is unique across the table.

#### **5.1.2 `DocumentMetadata` Table**

This table breaks out metadata into a key-value structure for each document version, enabling more granular or indexed queries

which are more efficient than querying the JSON content directly.

* **Primary Key (Composite):** `(verIdHi, verIdLo, fieldKey)`

  * Ties each metadata entry to a specific document version and a metadata key.

* **Fields:**

  * `fieldKey` (Text): The name/identifier of the metadata field (e.g., "author", "fund", "category").

  * `fieldValue` (Text): The value corresponding to that field key.

* **Indexes:**

  * `idx_doc_metadata_key_value` on `(fieldKey, fieldValue)`: Speeds up lookups by metadata key/value pairs.

#### **5.1.3 `Drafts` Table**

This table holds in-progress (draft) versions of documents that are not yet been made public or submitted.

This table contains encrypted data and is scoped to a user session and Catalyst keychain to maintain security and isolation.

* **Primary Key (Composite):** `(idHi, idLo, verIdHi, verIdLo)`

  * Matches the document identifier plus the version identifier, similar to `Documents`.

* **Fields:**

  * `type` (Text): Designation of the draft’s type (e.g., "proposal", "comment").

  * `encryptedContent` (Text): Securely stored (encrypted) draft content.

  * `sessionId` (Text): Associates the draft to a specific user session or encryption scope.

  * `push` (Int): Could be a flag indicating if/when the draft needs to be pushed/synced to the backend.

  * `title` (Text): Human-readable title for quick reference in the UI.

* **Indexes:**

  * `idx_draft_type` on `(type)`: Allows filtering drafts by type.

  * `idx_draft_sessionid` on `(sessionId)`: Facilitates queries that scope drafts to a particular user session.

### **5.2 UUID**

SQLite does not have built-in support for UUIDs to use UUIDs we need to store them as either Blobs INT8's.
IDHI/IDLO, or plain text.
Regardless of approach the date time should be extracted from the UUIDv7 document id or version and store in separate column.

Note, UUIDv7 is time-ordered by design therefore ordering is still possible regardless of approach, performance will vary.

#### **Option 1: BLOB Storage**

```sql

CREATE TABLE documents (id BLOB PRIMARY KEY);

```

**Advantages**:

* Direct binary storage (16 bytes).

* No conversion overhead

* Simpler implementation

#### **Option 2: TEXT Storage**

```sql

CREATE TABLE documents (id TEXT PRIMARY KEY);

```

**Advantages**:

* Human-readable for debugging.

* Direct string operations

#### **Option 3: INT8 Pair (Recommended)**

```sql

CREATE TABLE documents (

id_hi BIGINT NOT NULL, -- Upper 64 bits of UUIDv7

id_lo BIGINT NOT NULL, -- Lower 64 bits

PRIMARY KEY (id_hi, id_lo)

);
```

**Advantages**:

* Efficient range queries on timestamp (first 48 bits of `id_hi`).

* Native integer operations

* Smaller storage footprint

* Better indexing performance

The following approach should be taken for handling UUIDv7 Id and Version fields.
Both Id and Version fields should use **two `INT8`
columns (IDHI and IDLO)** rather than storing them as a BLOB or TEXT field, splitting them into two 64-bit integers (`INT8`) has
following advantages:

* **Better Indexing**

  * SQLite indexes `INT` columns efficiently.
  * Splitting UUIDs into two parts enables faster lookups.

* **Range Queries**:

  * With UUIDv7, the first 48 bits of the UUID represent a timestamp.
  * By storing the timestamp portion in one `INT8` column (`IDHI`), you can perform range-based searches.

* **Structured Operations**:
  * Separating the "time" and "random" portions of the UUID simplifies operations like sorting, filtering, and datetime extraction.

UUIDv7 is structured as follows:

* **First 48 bits (Timestamp)**: Milliseconds since Unix epoch.
* **Next 16 bits (Version and Variant)**: Metadata indicating UUID version and variant.
* **Last 64 bits (Random/Entropy)**: Randomly generated for uniqueness.

Spliting the UUIDv7 will align with the following approach:

* `IDHI`: Stores the first 64 bits (timestamp + version/variant).
* `IDLO`: Stores the last 64 bits (random/entropy).

## **6 Implementation**

### **6.1 JSON Document Handling**

#### **6.1.1 Indexes**

For front-end queries where fields are frequently used in a `WHERE` clause, it is recommended to create indexes to improve query
performance.
The overhead of creating these indexes should be evaluated over time based on the volume of data stored in the local
database.
Index creation is most beneficial for tables that store large amounts of data.
The specific fields to index should be
determined based on access patterns and usage, in alignment with UI/UX design.

Front-end engineers may decide to extract certain phrases from the JSON documents on insertion and store these fields in a metadata
table to be indexed, enabling quick lookups and document retrieval.

When using the Drift ORM, indexes are automatically created for certain columns and do not need to be defined manually.
This applies to:

* Primary keys
* Unique columns
* Target columns of a foreign key constraint

Indexes can also be created declaratively in Drift.
For instance, the following code will make queries based on `documentType` more efficient:

```dart
@TableIndex(name: 'document_type', columns: {#documentType})
class Documents extends Table {
  IntColumn get idHi => integer()();
  IntColumn get idLo => integer()();
  IntColumn get versionHi => integer()();
  IntColumn get versionLo => integer()();
  TextColumn get documentType => text()();
  TextColumn get content => text()();
  IntColumn get createdAt => integer()();
  TextColumn get metadata => text().nullable()();

  @override
  Set<Column> get primaryKey => {idHi, idLo};
}

```

#### **6.1.2 Dynamic Field Indexing for Lookups**

To ensure efficient look ups, dynamic indexes can be used to improve query performance.
The JSON document is stored in the primary
`documents` table, and a separate `document_metadata` table is used for quick look ups on specific fields.
This avoids parsing or
scanning the entire JSON document each time to filter or sort by a particular field.

#### **6.1.3 Process and Flow**

1. **Insert Document**

   * Insert the entire JSON-based document into the main `documents` table (which contains a composite primary key,
   for example `(id_hi, id_lo)`).

2. **Parse JSON**

   * Extract the fields you want to index (e.g., `title`, `description`, `category`) immediately after insertion.
   * Use best practices to identify suitable candidates for indexing based on query optimization, UI/UX design, and requirements.

3. **Insert Metadata**

   * Store the extracted field-value pairs in a separate `document_metadata` table that references the `documents` table via a
   foreign key.
   * Each field is stored as a separate row, for example:
     * `(doc_id_hi, doc_id_lo, fieldKey='title', fieldValue='My Title')`
     * `(doc_id_hi, doc_id_lo, fieldKey='category', fieldValue='Tutorial')`
   * You can insert additional fields (like `description`, tags, etc.) as needed.

4. **Search and Query**

   * When a filter or search is required on a particular field (e.g., `category='Development'`), query the `document_metadata`
   table by `(fieldKey, fieldValue)` or use a join with `documents`.
   * This avoids having to search through raw JSON each time.

**Flexible**: You can dynamically extract any fields you find valuable for quick look ups or queries without constantly
modifying the schema.  
**Performance**: Frequent queries on a few fields do not require scanning large JSON documents, as the metadata can be indexed
more efficiently.

> **Note**  
> In SQLite, foreign key references are not enabled by default.
> They must be enabled with `PRAGMA foreign_keys = ON`.

#### **6.1.4 Enabling Foreign Keys in SQLite**

Don’t forget to enable foreign keys in SQLite, as they are not enabled by default:

```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  beforeOpen: (details) async {
    await customStatement('PRAGMA foreign_keys = ON');
  },
);
```

#### **6.1.5 Example Drift definition with foreign reference and indexes**

```dart
@TableIndex(name: 'document_type', columns: {#documentType})
class Documents extends Table {
 IntColumn get idHi => integer()();
 IntColumn get idLo => integer()();

 // Columns are unique together
 IntColumn get verIdHi => integer()();
 IntColumn get verIdLo => integer()();

 TextColumn get documentType => text()();
 TextColumn get content => text()();
 IntColumn get createdAt => integer()();
 TextColumn get metadata => text().nullable()();

 @override
 Set<Column> get primaryKey => {idHi, idLo, verIdHi, verIdLo};

 @override
 List<Index> get indexes => [
   Index('idx_unique_ver_id', [verIdHi, verIdLo], unique: true),
 ];
}


class DocumentMetadata extends Table {
 // Composite key matching the Documents table over version not document fields
 IntColumn get verIdHi => integer().references(Documents, #verIdHi, onDelete: KeyAction.cascade, onUpdate: KeyAction.cascade)();
 IntColumn get verIdLo => integer().references(Documents, #verIdLo, onDelete: KeyAction.cascade, onUpdate: KeyAction.cascade)();

 // e.g. 'category', 'title', 'description'
 TextColumn get fieldKey => text()();

 // The actual value (for category, title, description, etc.)
 TextColumn get fieldValue => text()();

 @override
 Set<Column> get primaryKey => {verIdHi, verIdLo, fieldKey};

 @override
 List<Index> get indexes => [
   Index('idx_doc_metadata_key_value', [fieldKey, fieldValue]),
 ];
}

```

#### **6.1.6 Example search over category**

```dart
Future<List<Document>> fetchDocumentsByCategory(String category) {
  final query = (select(documents)
    ..where((doc) => existsQuery(
      select(documentMetadata)
        ..where((m) =>
            m.docIdHi.equals(doc.idHi) &
            m.docIdLo.equals(doc.idLo) &
            m.fieldKey.equals('category') &
            m.fieldValue.equals(category))
    ))
  );

  return query.get();
}

```

### 6.2 **UUID Conversion to IOHI / IDLO**

To split a UUID into `IDHI` and `IDLO`:

* Convert the UUID into its raw binary representation (16 bytes).
* Split the binary into two 8-byte chunks.
* Convert each chunk into a 64-bit integer.

#### **6.2.1 UUIDv7 Example Handler & Timestamp Extraction**

```dart
class UuidV7Handler {
 // Convert UUID to INT8 pairs
 static (int, int) uuidToInts(String uuid) {
  final bytes = hex.decode(uuid.replaceAll('-', ''));
  final high = ByteData.sublistView(bytes, 0, 8).getInt64(0);
  final low = ByteData.sublistView(bytes, 8, 16).getInt64(0);
  return (high, low);
 }

 static DateTime extractTimestamp(int id_hi) {
        final msTimestamp = id_hi >> 16;
        return DateTime.fromMillisecondsSinceEpoch(msTimestamp);
    }
}
```

#### **6.2.2 UUIDv7 Time-Range Query Optimisation**

Query `IDHI` directly for range-based filtering in the `Document` table.

```dart
// Time-range query using UUIDv7 high bits
Stream<List<Document>> getDocumentsInTimeRange(DateTime start, DateTime end) {
 final startHigh = start.millisecondsSinceEpoch << 16;
 final endHigh = end.millisecondsSinceEpoch << 16;
 return (select(documents)..where((d) => d.idHi.isBetween(startHigh, endHigh)))
  .watch();
}
```

## **7 Draft Document Management**

This section outlines a secure, cross-platform architecture for managing **local drafts** within catalyst.
By leveraging
**SQLite with JSON1**, **ephemeral session keys**, and **deterministic encryption strategies**, this approach ensures that drafts
are both securely stored and readily accessible to authenticated users.
The architecture also lays the groundwork for potential
future features, such as device synchronization, without compromising the core design principles.

Drafts are documents that are **not yet published** to an external public data store or API, allowing users to create and edit
content locally.
These drafts are inherently **mutable** and can contain **sensitive information**, making their security and
isolation essential.
Once published any document is considered immutable, in the public domain and permanently available to others.

This requirement stems from several factors:

1. **Privacy**: Drafts often contain sensitive information not yet ready for public viewing.
2. **Offline Capability**: Users should be able to work on drafts without the need to connect to a server.
3. **Performance**: Local storage reduces latency compared to constant server interactions.
4. **Data Control**: Users maintain control over their data until they choose to publish it.
5. **Future Synchronization**: While out of scope at present, deterministic session keys enable the potential for syncing encrypted
   data across devices.

### **7.1 Storage Options**

While consideration was given to various storage options for drafts, the overall storage solution decision was made in a wider
context and the approach defined here for drafts will align with the previous decision of using SQLite as the local data store with
Drift as the ORM.
Other solutions were considered for draft storage like Hive and IndexedDB however these lacked key features and
support defined at a system level.

### **7.2 Encryption & Session Management**

> note
>
> * Data stored in a Drift database is persisted across sessions.
> * Drift's use of SQLite as its underlying storage engine ensures that data remains intact even when the application is closed or
> the device is restarted.
> * This persistence applies across all
> supported platforms, including web applications.
> * Data persistence can be affected if the user manually clears application
> data or cache.

Catalyst drafts are mutable, private documents that the owner retains full control of until publication.
Encryption ensures that
drafts are protected both at rest and during use, even if the local database is accessed by unauthorized parties.

The need for encryption arises from:

1. Preventing Unauthorized Access
2. Securing Shared Devices
3. Future Device Sync

To secure drafts effectively, an ephemeral **session key** and  **encryption key** are required to encrypt and decrypt draft data
during an active session.

This approach provides several advantages:

* **Ephemeral Security**: The keys is tied to the user's session and only exists in memory during that session.
  It is wiped upon
logout, session timeout, or inactivity, reducing the attack surface.
  Persisted draft data is tied to the session key.
* **Session Isolation**: A session-specific key ensures that data is logically and cryptographically isolated for each user session,
  preventing unauthorized access in shared environments.
* **Deterministic Key Requirements**: While the keys themselves are ephemeral, they must be derived in a deterministic manner to
  allow for future decryption and cross-device sync.
* **Considerations:**
  * When saving a draft, include the current session ID.
  * On logout or session timeout, delete all drafts associated with the session ID.
  * Implement a background job to periodically clean up orphaned drafts from expired sessions.

### **7.3 Key Derivation Process**

TBD: needs input from front end developers on existing approach, however it can be assumed we must have a deterministic ephemeral
encryption and session key.

Discuss further on best alignment
code : catalyst_voices_services packages, key_derivation, crypto_service

**Session and Encryption Key Generation**:

* A session-specific key is derived from the user key using HKDF (HMAC-based Key Derivation Function).
* The derivation process incorporates a unique session identifier.

### **7.4 Draft Encryption Workflow**

* **Draft Creation and Editing**:
  * Draft content is kept in plaintext in memory while being edited.
  * When saving, metadata (e.g., title, status) is extracted and stored unencrypted for efficient querying.
  * The main content is encrypted using the encryption key.
* **Storing Encrypted Drafts**:
  * Encrypted proposal drafts need to be stored in the drafts table, this table will use a session key to identify individual
    documents tied to a session in shared environments.
* **Accessing Drafts**:
  * The app fetches encrypted content from `drafts` table.
  * Content is decrypted using the in-memory encryption key.
* **Session Timeout / Logout**:
  * The session key is securely wiped from memory.
  * All drafts associated with the expired session remain encrypted and inaccessible.
* **Re-authentication**:
  * When a user re-authenticates with the application the session key and the encryption key are derived again and stored in
    memory.

### **7.5 Draft Database Design**

Drift does not support table-level encryption, so handling encryption/decryption at the application level is necessary however we
can abstract this into the repository storage layer for clean separation of code.
Separating drafts into their own database could
complicate queries and degrade performance due to cross-database operations.

To mitigate exposure of private data in shared environments each row in the drafts table needs to be tied to a session key.
Within the application our session key needs to be deterministic to facilitate decryption of data when cross device synchronisation
is required in future iterations.

This session key is **NEVER** to be persisted in the database in plain text but is required to determine which rows in the drafts
table are linked to a session.

To address the security risks of exposing the session key, such as vulnerabilities to attacks like session hijacking and rainbow
table attacks, the session key must be derived using a **cryptographically secure, one-way deterministic function**, t should be
designed to be **computationally non-reversible**, ensuring that the parent key cannot be determined from the session key.

Additionally, the derivation process must incorporate mechanisms such as **high entropy inputs or salting** to ensure resistance
against brute-force attacks.

```dart
@TableIndex(name: 'idx_draft_type', columns: {#type})
class Drafts extends Table {
  // Composite key for document identification
  IntColumn get idHi => integer()();
  IntColumn get idLo => integer()();

  // Unique version identifier for the draft
  IntColumn get verIdHi => integer()();
  IntColumn get verIdLo => integer()();

  TextColumn get type => text()();

  // Encrypted content of the draft
  TextColumn get encryptedContent => text()();

  // Session id identifying the content to a particular session
  TextColumn get sessionId => text()();

  // Epoch used to identify time draft was explicitly saved
  IntColumn get push => integer().nullable()();

  // Public display name of the document
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {idHi, idLo, verIdHi, verIdLo};

  @override
  List<Index> get indexes => [
        Index('idx_draft_type', [type]),
        Index('idx_draft_sessionid', [sessionId])
      ];
}
```

## **8 Offline & Synchronization Strategy**

All operations that can be performed locally should be performed locally first.
This ensures low latency, offline functionality,
and better performance by reducing reliance on external APIs.
Synchronization with the server (index API and document API) is
performed intelligently to maintain data consistency without compromising offline usability.

### 8.1. **Local-First Operations**

* **Key Principle:** Any operation that can operate on local cached data should do so first.
* **Operations That Should Be Supported Locally:**
  * Creating new drafts.
  * Editing existing drafts.
  * Viewing cached documents.
  * Querying local metadata for document lists or details.
* **Fallback:** For operations where the required data is not available locally, fetch the necessary document or index data from
  the API and update the local cache.

### 8.2. **Document Retrieval Workflow**

* **When Requesting a Document (By ID or ID and Version):**
  * **Check Local Cache:**
    * If the document request is available locally **and the request includes a version**, the document is returned from the
      local cache.
  * **If Only an ID is Provided (No Document Version Specified):**
    * If no version is specified in the request, there is no way to determine if any document version stored in the local cache
      is the latest version therefore a request to the api is required to get the documents metadata and list of versions.
    * **Query the Index API** to fetch the full version history of the document.
    * Update the local metadata cache with the latest version info.
    * If the latest version is not cached locally:
      * Fetch the latest version from the document API.
      * Cache it locally for future access.
      * Return the latest version to the user.
  * **If ID and Version Are Provided:**
    * Check if the specified version exists locally.
    * If not found, fetch it from the document API and cache it locally.

### 8.3. **Index API Usage**

* **Purpose:** The index API is used to retrieve metadata about documents, such as available document IDs, versions, and other
  attributes.
* **Triggers for Index API Calls:**
  * On application startup if the client is online: Perform an initial lightweight sync to ensure the required metadata is up to
    date.
  * (Optional with performance consideration) Periodically in the background: Configurable intervals ensure ongoing metadata
    synchronisation.
  * On user request: Explicit refreshes initiated by the user.
  * When a document is requested by ID only and the local cache cannot verify its latest version.
* **Filtered Queries:** The index API can return metadata for a subset of documents to minimize bandwidth and local storage usage.

### 8.4. **Draft Management**

* **Local-Only Drafts:**
  * Drafts are created and stored exclusively in the **local drafts table**.
  * Changes to drafts are not synced to the server until explicitly published as a final document.
* **Draft Synchronization:**
  * On publication, the draft is sent to the document API.
  * If the publication succeeds:
    * The draft can be stored in the regular documents table, as the document owner and the user of the client are the same new
    versions of the document can be edited and stored in the draft table however the draft must be signed and published again
    is it is to supersede a previous version.
    * Local metadata is updated with the published version info.
  * If the publication fails:
    * The draft remains in the drafts table.
    * Notify the user of the failure and allow retry upon regaining connectivity.
  * If an older draft is edited locally and saved it will get a new version id, this will become the latest version in the local
    draft database, if this draft is published it will supersede the previously published version even if it does not contain all of
    the data from the previous public version, the responsibility for draft management and versioning is the responsibility of the
    document owner.

### 8.5. **Version Management**

* **UUIDv7 for Versions:**
  * Document versions are identified using UUIDv7, which encodes a timestamp for chronological ordering.
  * This allows efficient sorting and comparison of document versions.
* **Version Lookup:**
  * If a document is requested **without specifying a version**, the index API must be queried to retrieve the full version
    history of the document.
  * The latest version in the metadata is compared against the locally cached version:
    * If the latest version is not cached locally, fetch it from the document API and update the cache.
* **Conflict Prevention:**
  * Always rely on the latest version metadata from the index API when there’s uncertainty about the latest version.

### 8.6. **Conflict Resolution**

* **Published Documents:** Always defer to the latest version retrieved from the server.
* **Drafts:** A last-write-wins strategy (new version id) is applied locally, using timestamps from UUIDv7 to determine the most
  recent change, collaborative or cross device conflict resolution is out of scope at present.

### 8.7. **Offline Mode**

* **Offline Capability:** All local operations, such as creating, editing drafts, and querying cached data, continue to function
  without network connectivity.
* **Queuing Failed Requests:**
  * API requests (e.g., fetches, publications) that fail due to connectivity issues can be queued, however the queue should be
    limited in size and only used for requests relating to the operation of the client, for example requesting the latest
    `Category Parameters Document`
  * Upon reconnecting to the network, queued requests are processed in order.
* **Fallback Retrieval:** If a document isn’t cached locally during offline mode, display an error or notify the user of the need
  to reconnect.

### 8.8. Client metadata bootstrap

* **Fixed document definitions**
  * Catalyst defines fixed document types and identifiers, these type ids will not change and can be used to identify the
    latest documents required to bootstrap a client.
    Examples include, the `Brand Parameters Document`,
    `Campaign Parameters Document`, `Category Parameters Document`.
  * The ids of these document types can be used to pull the latest documents from the API when boot straping the client and
    performing initial local caching operations.
  * A list of document types and specifications can be
    found [here](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/)

### 8.9. **Background Synchronisation (Optional)**

* **Consideration:** Before implementing any background synchronisation consider if it is necessary and if the same result can be
  achieved using explicit requests when required.
* **Purpose:** Keep local metadata and document caches up to date while minimizing bandwidth and performance considerations.
* **Sync Triggers:**
  * Periodic intervals (configurable by the user).
  * Application startup.
  * Explicit user action (manual refresh).
* **Lightweight Syncing:**
  * Fetch only critical metadata updates (e.g., new document versions, added documents).
  * Avoid unnecessary retrieval of documents already cached and up-to-date locally.

### **8.10 Performance Considerations**

1. **Local Storage Limits:**
   * Local storage may be limited, and caching large document datasets may not be possible.
   * To mitigate this implement size limits on the local data base and eviction policies for documents and metadata.
2. **Offline Queue Management:**
   * Large queues of failed API requests in offline mode could lead to delays or failures upon reconnecting.
   * Limit the size of the offline queue and only allow critical requests as pending operations.
3. **Metadata Inflation:**
   * Regular updates to the metadata table could lead to bloating, especially with frequent version changes.
   * Periodically clean up old metadata entries or versions no longer relevant, a least recently used (LRU) policy can be
     implemented however it is out of scope to track access patterns in local storage.

## **9 Local Cache Management**

### **9.1 Local Data Store Inflation**

Data store inflation occurs when frequent updates to the metadata and documents table result in excessive data accumulation,
leading to:

* **Performance Degradation:** Increased query times due to a large volume of outdated or redundant metadata entries.
* **Storage Inefficiency:** Consuming unnecessary disk space with metadata for outdated document versions or unused fields.
* **Maintenance Overhead:** Difficulty managing or cleaning up stale metadata entries, especially in a long-lived application with a
  large number of documents and versions.

The main contributing factors to data store inflation are:

* Frequent Version Changes: Each version of a document introduces a new set of metadata entries, even if many fields remain
  unchanged.
* **Stale Metadata:** Metadata for outdated or deleted versions accumulates over time.
* **Redundant Data:** Repeatedly storing unchanged metadata across versions leads to unnecessary duplication.
* **Unused Metadata:** Rarely accessed metadata fields remain in the table without being purged.

### **9.2 Metadata Retention Policy**

* **Keep recent and frequently accessed versions' metadata locally.**
* Remove metadata for older versions that are not accessed frequently.

Retention Criteria:

* **Recent Versions:**
  * Retain metadata for the latest `N` versions (e.g., the last 10 versions) of each document.
* **Fallback:**
  * For metadata removed from local storage, allow on-demand retrieval from the server.

### **9.3 Cache RFC 9111**

RFC 9110 and RFC 9111 Define specifications for supporting caching of HTTP requests and managing expiry and freshness of data.
By utilizing these predefined request headers periodic cleanup of expired documents will reduce the problem of data store inflation.
RFC9111 Specifics a number of Field Definitions and Directives that can be used to improve local caching efficiency.

* **5.3 Expires**: The "Expires" response header field gives the date/time after which the response is considered stale.
* **5.2.2.1 max-age**: The max-age response directive indicates that the response is to be considered stale after its age is greater
  than the specified number of seconds.
* **5.2.2.4 no-cache**: The no-cache response directive, in its unqualified form (without an argument), indicates that the response
  MUST NOT be used to satisfy any other request without forwarding it for validation and receiving a successful response.
* **5.2.2.5 no-store**: The no-store response directive indicates that a cache MUST NOT store any part of either the immediate
  request or the response and MUST NOT use the response to satisfy any other request.

### **9.4 Cache RFC 9111 Implementation**

All responses from the API must verify if the following directives are present:

* **`no-cache`:**
  * Indicates that the document must not be reused without re-validation, a document with no-cache present in the header can be
    stored locally however validation is required by requesting from the index api the latest metadata about the document to verify
    if it is the most up to date.
* **`no-store`:**
  * Means the document must not be stored at all.
    If this directive is present, you should **not cache the document**

If `expires` or `max-age` are preset in the header the expiry date should be calculated in as a UNIX epoch and stored alongside the
document, this will be calculated as follows

#### **9.4.1 Modified `Documents` Table**

```dart

class Documents extends Table {
  IntColumn get idHi => integer()();
  IntColumn get idLo => integer()();

  // Columns are unique together
  IntColumn get verIdHi => integer()();
  IntColumn get verIdLo => integer()();

  TextColumn get documentType => text()();
  TextColumn get content => text()();
  IntColumn get createdAt => integer()();
  TextColumn get metadata => text().nullable()();

  // Cache-specific columns
  IntColumn get expiresAt => integer().nullable()(); // Expiry timestamp (Unix epoch)
  BoolColumn get noCache => boolean().withDefault(const Constant(false))();   // If "no-cache" directive applies

  @override
  Set<Column> get primaryKey => {idHi, idLo, verIdHi, verIdLo};

  @override
  List<Index> get indexes => [
    Index('idx_unique_ver_id', [verIdHi, verIdLo], unique: true),
  ];
}

```

#### **9.4.2 Header Verification**

##### **9.4.2.1 no-cache and no-store**

**`no-cache`**

* **Directive Behaviour:**

  * The document can be cached (stored locally, either in memory or a database).
  * **Before reuse**, the document must be validated against the server to ensure it's still fresh.
  * Validation can be done by sending a conditional request to the API or due to the immutable nature of documents a request to the
  index endpoint to verify the document is still the latest version.

  **`no-store`**

* **Directive Behaviour:**
  * The document must not be cached or stored in any form—neither in memory nor persistent storage.
  * Every request for the document must be a new request to the server.

##### **9.4.2.2 expires and max-age**

* **Directive Behavior:**
  * **`expires`:** Specifies the absolute expiration date and time for the resource.
  * **`max-age`:** Specifies the relative expiration time in seconds from the time of the response.
* **Implementation Steps:**
* Check if the `Expires` or `Cache-Control: max-age` header is present in the response.
* If `Expires` is present:
  * Parse the `Expires` header as a date/time value.
  * Convert it to a UNIX epoch timestamp and store it as `expiresAt` in the database.
* If `max-age` is present:
  * Calculate `expiresAt` as: `currentTimestamp + max-age`
  * Store the resulting UNIX epoch timestamp in the database.
* If both `Expires` and `max-age` are present:
  * Use the `max-age` directive, as it takes precedence over `Expires`.

#### **9.4.3 Directive Validation Workflow**

* **Check if the document exists locally:**
  * Query the local database to see if the document is stored.
* **If the document does not exist locally:**
  * Fetch the document from the API.
  * If the API response allows caching (not `no-store`), store it in the database with the appropriate expiration time
    (if `expires` or `max-age` is present).
* **If the document exists locally:**
  * Check if the `noCache` flag is `true`:
    * If `true`, validate the document with the API before using it.
      * If the document is valid use the local version.
      * If the document is invalid, fetch a fresh version from the API and update the local database.
  * If `noCache` is `false`:
    * Check if the document is expired (compare `expiresAt` with the current time).
      * If expired, fetch a fresh version from the API and update the local database.
      * If not expired, use the locally cached version.
* **Return the document:**
  * Use the local version if valid and not expired, or the fresh version from the API otherwise.

#### **9.4.4 Periodic Cleanup of Expired Documents**

To manage metadata inflation and optimize storage, a cleanup process should periodically remove expired documents and their
associated metadata from the database.
Documents with an `expiresAt` timestamp should be prioritized, with entries deleted once the current time exceeds their expiration.
However, some documents may not have an `expiresAt` value, meaning they are not explicitly set to expire.
For such documents, the application should define a retention policy based on the `createdAt` timestamp to ensure old, unused
data is removed.
This policy might involve keeping documents for a specific duration (e.g., 60 days) and deleting entries older than that threshold.
This approach ensures efficient storage management, prevents bloating from obsolete entries, and allows the system to balance
document retention and resource constraints effectively.

## **10 API Integration Details**

### **10.1 Document Retrieval**

#### **Endpoint**

```http
GET /api/draft/document/{document_id}
```

#### **Parameters**

* **`document_id`**: UUIDv7 – The unique identifier for the document.
* **`version`**: UUIDv7 (optional) – Specifies the version of the document to retrieve.
  If omitted, the latest version is retrieved.

#### **Responses**

* **`200 OK`**: Document retrieved successfully.
* **`401 Unauthorized`**: Authentication failed or session expired.
* **`403 Forbidden`**: User does not have permission to access the document.
* **`404 Not Found`**: Document with the specified ID or version does not exist.

### **10.2 Document Storage**

#### **Endpoint**

```http
PUT /api/draft/document
```

#### **Request Body**

* The document should be encoded in CBOR format before submission.

#### **Responses**

* **`201 Created`**: Document created successfully.
* **`204 No Content`**: Document already exists in the store.
* **`400 Bad Request`**: The document format is invalid or the request is malformed.
* **`413 Payload Too Large`**: Document exceeds the allowed size limit.

### **10.3 Document Index**

#### **Endpoint**

```http
POST /api/draft/document/index
```

#### **Parameters**

* **`page`**: Number (default: 0) – Specifies the pagination offset.
* **`limit`**: Number (default: 100) – Specifies the maximum number of documents to return per request.

#### **Request Body**

* Query filter specification to narrow down the indexed results.

#### **Responses**

* **`200 OK`**: Document index retrieved successfully.
* **`404 Not Found`**: No documents match the query filter.

### **10.4 Updated API Specification**

For the latest and most detailed API specification, refer to the following location:  
[Updated API Specification](https://input-output-hk.github.io/catalyst-voices/api/cat-gateway/openapi-swagger/)

## 11 Out of Scope

* Device Synchronization
  * Multi-device sync, conflict resolution, P2P.
* Multiple Storage Providers
  * Alternative backends, cloud storage, distributed systems.
* Advanced Collaboration
  * Real-time multi-user editing, differential sync, IPFS integration.
* Index Synchronization
  * Remote or distributed index updates.

## 12 Known Limitations

* JSON Storage
  * Complex queries may affect performance.
  * Drift lacks native JSONB; using TEXT with JSON1.
  * Large documents can cause high memory usage.
* Draft Security
  * Session key must be re-derived after app restart.
  * Metadata remains unencrypted, risking partial data leaks however owner should be notified when saving drafts.

## **13 References**

* **RFC 9111 (Caching HTTP Requests and Responses)**  
  * [RFC 9111 Specification](https://datatracker.ietf.org/doc/rfc9111/)

* **RFC 9110 (HTTP Semantics)**  
  * [RFC 9110 Specification](https://datatracker.ietf.org/doc/rfc9110/)
* **SQLite**
  * [SQLite Official Website](https://sqlite.org/index.html)
  * [SQLite JSON1 Extension](https://sqlite.org/json1.html)
  * [SQLite UUIDv7 Proposal](https://www.ietf.org/archive/id/draft-ietf-uuidrev-rfc4122bis-00.html) (for UUIDv7-related details).
* **Drift ORM**
  * [Drift Documentation](https://drift.simonbinder.eu/)
  * A type-safe database library for Flutter that supports SQLite.
* **Flutter**
  * [Flutter Official Documentation](https://flutter.dev/docs)
  * [sqlite3_flutter_libs Plugin](https://pub.dev/packages/sqlite3_flutter_libs)
* **Dart**
  * [Dart Official Documentation](https://dart.dev/)
* **HKDF (HMAC-based Key Derivation Function)**
  * [RFC 5869: HKDF](https://datatracker.ietf.org/doc/rfc5869/)
* **UUIDv7 Specification**
  * [UUID Revision Specification (IETF Draft)](https://datatracker.ietf.org/doc/draft-ietf-uuidrev-rfc4122bis/)
* **Catalyst Signed Document Types**
  * [Catalyst Document Types Reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/)

* **Catalyst API**
  * [Catalyst API Swagger Documentation](https://input-output-hk.github.io/catalyst-voices/api/cat-gateway/openapi-swagger/)
* **CBOR Encoding**
  * [CBOR Specification (RFC 8949)](https://datatracker.ietf.org/doc/rfc8949/)
