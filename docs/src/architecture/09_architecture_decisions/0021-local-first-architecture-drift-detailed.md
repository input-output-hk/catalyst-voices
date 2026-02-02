---
    title: 0021 Local-First Architecture with Drift - Detailed Implementation
    adr:
        author: Catalyst Engineering Team
        created: 15-Jan-2024
        status: accepted
    tags:
        - flutter
        - database
        - offline
        - frontend
        - drift
        - sqlite
---

## Context

The Catalyst Voices application must:

* Work offline with full functionality
* Provide fast, responsive UI
* Cache data locally for performance
* Support complex queries on JSON documents
* Work across Web, iOS, and Android platforms
* Store document content efficiently with JSONB support

We need a local database solution that supports:

* SQLite with JSONB support (3.45.0+)
* Type-safe queries
* Reactive streams for UI updates
* Schema migrations
* Cross-platform compatibility
* Efficient storage of large document content

ADR 0015 established the high-level decision to use Drift.
This ADR provides detailed implementation decisions.

## Decision

We use **Drift** (formerly Moor) as our local database solution with:

1. **SQLite Backend**: Native SQLite on mobile, WASM SQLite on Web
2. **JSONB Support**: Leverage SQLite 3.45.0+ JSONB functions for document queries
3. **BlobColumn for Document Content**: Use `BlobColumn` with type converters for efficient document storage
4. **Reactive Streams**: Drift's watch queries for automatic UI updates
5. **Type Safety**: Generated code from Dart table definitions
6. **Migrations**: Versioned schema migrations with Drift
7. **Complex Queries**: Support for complex SQLite queries with JSONB functions

## Implementation Details

### Database Schema with BlobColumn

Documents are stored using `BlobColumn` with type converters for efficient storage:

```dart
mixin DocumentTableContentMixin on Table {
  BlobColumn get content => blob().map(DocumentConverters.content)();
}

@DataClassName('DocumentRow')
class DocumentsV2 extends Table with DocumentTableContentMixin {
  TextColumn get id => text()();
  TextColumn get ver => text()();
  BlobColumn get content => blob().map(DocumentConverters.content)();
  TextColumn get authors => text().map(DocumentConverters.catId)();
  TextColumn get collaborators => text().map(DocumentConverters.catId)();
  // ... other columns
}
```

The `DocumentConverters.content` converter handles JSONB serialization:

```dart
static final DocumentContentJsonBConverter content = TypeConverter.jsonb(
  fromJson: (json) => DocumentDataContent(json! as Map<String, Object?>),
  toJson: (content) => content.data,
);
```

### Repository Pattern

```dart
class DocumentRepository {
  final CatalystDatabase _db;

  Stream<List<Document>> watchDocuments() {
    return _db.select(_db.documentsV2).watch();
  }

  Future<void> insertDocument(Document doc) async {
    await _db.into(_db.documentsV2).insert(
      DocumentsV2Companion.insert(
        id: doc.id,
        ver: doc.version,
        content: doc.content, // Automatically converted via BlobColumn
      ),
    );
  }

  // Complex queries with JSONB functions
  Future<List<Document>> queryDocumentsByCategory(String categoryId) {
    return (_db.select(_db.documentsV2)
      ..where((tbl) =>
        json_extract(tbl.content, '$.metadata.parameters.categories')
        LIKE '%$categoryId%'
      )).get();
  }
}
```

### Web Platform Considerations

* Requires `sqlite3.v1.wasm` and `driftWorker.js`
* Needs CORS headers: `Cross-Origin-Opener-Policy: same-origin` and `Cross-Origin-Embedder-Policy: require-corp`
* WASM files must be served with `Content-Type: application/wasm`
* Database configuration:

```dart
CatalystDatabase.drift(
  config: CatalystDriftDatabaseConfig(
    name: config.name,
    web: CatalystDriftDatabaseWebConfig(
      sqlite3Wasm: Uri.parse(config.webSqlite3Wasm),
      driftWorker: Uri.parse(config.webDriftWorker),
    ),
    native: CatalystDriftDatabaseNativeConfig(
      dbDir: () => path.getApplicationDocumentsDirectory().then((dir) => dir.path),
      dbTempDir: () => path.getTemporaryDirectory().then((dir) => dir.path),
    ),
  ),
)
```

### Complex SQLite Queries

The application uses complex SQLite queries with JSONB functions for document filtering and searching:

* JSONB extraction for filtering by document metadata
* Complex joins across document tables
* Efficient indexing on JSONB columns
* Pagination support with JSONB-based filtering

## Alternatives Considered

### Hive

* **Pros**: NoSQL, simple API
* **Cons**: No SQL queries, limited query capabilities, no JSONB support
* **Rejected**: Need SQL queries for complex document filtering

### Isar

* **Pros**: Fast, good query capabilities
* **Cons**: Less mature, smaller community, no JSONB support
* **Rejected**: Drift has better cross-platform support and JSONB capabilities

### sqflite (direct SQLite)

* **Pros**: Direct SQLite access
* **Cons**: No type safety, manual migrations, no reactive streams, no JSONB type converters
* **Rejected**: Drift provides better developer experience and type safety

### TextColumn for Document Content

* **Pros**: Simpler serialization
* **Cons**: Less efficient storage, no native JSONB support
* **Rejected**: BlobColumn with converters provides better performance and JSONB query support

## Consequences

### Positive

* Full offline functionality
* Fast local queries with indexing
* Reactive UI updates via streams
* Type-safe database operations
* Cross-platform compatibility
* Efficient storage with BlobColumn
* Complex queries with JSONB functions
* JSONB-based document filtering and searching

### Negative

* SQLite version requirement (3.45.0+)
* Web platform requires WASM setup
* Migration complexity for schema changes
* Initial database setup overhead
* BlobColumn requires type converter implementation

### Follow-up Work

* Document migration procedures
* Establish JSONB query patterns
* Create database testing utilities
* Document BlobColumn converter patterns
* Performance optimization for large documents
