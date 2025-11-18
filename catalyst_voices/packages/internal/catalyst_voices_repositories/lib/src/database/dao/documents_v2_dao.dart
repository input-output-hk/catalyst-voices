import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_with_authors_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

abstract interface class DocumentsV2Dao {
  /// Returns the total number of documents in the table.
  Future<int> count();

  /// Deletes documents that meet a specific condition and returns the number of
  /// documents deleted.
  ///
  /// This method is intended to be implemented by a concrete class that defines
  /// the deletion criteria. For example, it could delete all documents that are
  /// older than a certain date.
  Future<int> deleteWhere({
    List<DocumentType>? notInType,
  });

  /// Checks if a document exists by its reference.
  ///
  /// If [ref] is exact (has version), checks for the specific version.
  /// If loose (no version), checks if any version with the id exists.
  /// Returns true if the document exists, false otherwise.
  Future<bool> exists(DocumentRef ref);

  /// Filters and returns only the DocumentRefs from [refs] that exist in the database.
  ///
  /// Optimized for performance: Uses a single query to fetch all relevant (id, ver) pairs
  /// for unique ids in [refs], then checks existence in memory.
  /// - For exact refs: Matches specific id and ver.
  /// - For loose refs: Checks if any version for the id exists.
  /// Suitable for synchronizing many documents with minimal database round-trips.
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs);

  /// Retrieves a document.
  ///
  /// If [ref] is provided and is exact (has version), returns the specific version.
  /// If [ref] is loose (no version), returns the latest version by createdAt.
  /// If [author] is non null tries to find matching document
  /// Returns null if no matching document is found.
  Future<DocumentEntityV2?> getDocument({
    DocumentRef? ref,
    CatalystId? author,
  });

  /// Retrieves a list of documents that match the given criteria.
  ///
  /// This method returns a list of documents that match the given criteria.
  /// - [id]: optional filter to only include documents with matching id.
  /// - [type]: Optional filter to only include documents of a specific [DocumentType].
  /// - [filters]: Optional campaign filter.
  /// - [latestOnly] is true only newest version per id is returned.
  /// - [limit]: The maximum number of documents to return.
  /// - [offset]: The number of documents to skip for pagination.
  Future<List<DocumentEntityV2>> getDocuments({
    String? id,
    DocumentType? type,
    CampaignFilters? filters,
    bool latestOnly,
    int limit,
    int offset,
  });

  /// Finds the latest version of a document.
  ///
  /// Takes a [ref] (which can be loose or exact) and returns a [DocumentRef]
  /// pointing to the latest known version of that document.
  Future<DocumentRef?> getLatestOf(DocumentRef ref);

  /// Saves a single document, ignoring if it conflicts on {id, ver}.
  ///
  /// Delegates to [saveAll] for consistent conflict handling and reuse.
  Future<void> save(DocumentWithAuthorsEntity entity);

  /// Saves multiple documents in a batch operation, ignoring conflicts.
  ///
  /// [entries] is a list of DocumentEntity instances.
  /// Uses insertOrIgnore to skip on primary key conflicts ({id, ver}).
  Future<void> saveAll(List<DocumentWithAuthorsEntity> entries);

  /// Watches for a list of documents that match the given criteria.
  ///
  /// This method returns a stream that emits a new list of documents whenever
  /// the underlying data changes.
  /// - [id]: optional filter to only include documents with matching id.
  /// - [type]: Optional filter to only include documents of a specific [DocumentType].
  /// - [filters]: Optional campaign filter.
  /// - [latestOnly] is true only newest version per id is returned.
  /// - [limit]: The maximum number of documents to return.
  /// - [offset]: The number of documents to skip for pagination.
  Stream<List<DocumentEntityV2>> watchDocuments({
    String? id,
    DocumentType? type,
    CampaignFilters? filters,
    bool latestOnly,
    int limit,
    int offset,
  });
}

@DriftAccessor(
  tables: [
    DocumentsV2,
    DocumentAuthors,
  ],
)
class DriftDocumentsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDocumentsV2DaoMixin
    implements DocumentsV2Dao {
  DriftDocumentsV2Dao(super.attachedDatabase);

  @override
  Future<int> count() {
    return documentsV2.count().getSingleOrNull().then((value) => value ?? 0);
  }

  @override
  Future<int> deleteWhere({
    List<DocumentType>? notInType,
  }) {
    final query = delete(documentsV2);

    if (notInType != null) {
      query.where((tbl) => tbl.type.isNotInValues(notInType));
    }

    return query.go();
  }

  @override
  Future<bool> exists(DocumentRef ref) {
    final query = selectOnly(documentsV2)
      ..addColumns([const Constant(1)])
      ..where(documentsV2.id.equals(ref.id));

    if (ref.isExact) {
      query.where(documentsV2.ver.equals(ref.version!));
    }

    query.limit(1);

    return query.getSingleOrNull().then((result) => result != null);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs) async {
    if (refs.isEmpty) return [];

    final uniqueIds = refs.map((ref) => ref.id).toSet();

    // Single query: Fetch all (id, ver) for matching ids
    final query = selectOnly(documentsV2)
      ..addColumns([documentsV2.id, documentsV2.ver])
      ..where(documentsV2.id.isIn(uniqueIds));

    final rows = await query.map(
      (row) {
        final id = row.read(documentsV2.id)!;
        final ver = row.read(documentsV2.ver)!;
        return (id: id, ver: ver);
      },
    ).get();

    final idToVers = <String, Set<String>>{};
    for (final pair in rows) {
      idToVers.update(
        pair.id,
        (value) => value..add(pair.ver),
        ifAbsent: () => <String>{pair.ver},
      );
    }

    return refs.where((ref) {
      final vers = idToVers[ref.id];
      if (vers == null || vers.isEmpty) return false;

      return !ref.isExact || vers.contains(ref.version);
    }).toList();
  }

  @override
  Future<DocumentEntityV2?> getDocument({
    DocumentRef? ref,
    CatalystId? author,
  }) {
    final query = select(documentsV2);

    if (ref != null) {
      query.where((tbl) => tbl.id.equals(ref.id));

      if (ref.isExact) {
        query.where((tbl) => tbl.ver.equals(ref.version!));
      }
    }

    // TODO(damian-molinski): test it
    if (author != null) {
      final significant = author.toSignificant().toUri().toString();
      query.where((tbl) {
        final authorDocs = subqueryExpression<String>(
          selectOnly(documentAuthors)
            ..addColumns([documentAuthors.documentId])
            ..where(documentAuthors.authorIdSignificant.equals(significant))
            ..where(documentAuthors.documentId.equalsExp(documentsV2.id)),
        );
        return tbl.id.equalsExp(authorDocs);
      });
    }

    query
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
      ..limit(1);

    return query.getSingleOrNull();
  }

  @override
  Future<List<DocumentEntityV2>> getDocuments({
    String? id,
    DocumentType? type,
    CampaignFilters? filters,
    bool latestOnly = false,
    int limit = 200,
    int offset = 0,
  }) {
    return _queryDocuments(
      id: id,
      type: type,
      filters: filters,
      latestOnly: latestOnly,
      limit: limit,
      offset: offset,
    ).get();
  }

  @override
  Future<DocumentRef?> getLatestOf(DocumentRef ref) {
    final query = selectOnly(documentsV2)
      ..addColumns([documentsV2.id, documentsV2.ver])
      ..where(documentsV2.id.equals(ref.id))
      ..orderBy([OrderingTerm.desc(documentsV2.createdAt)])
      ..limit(1);

    return query
        .map(
          (row) => SignedDocumentRef.exact(
            id: row.read(documentsV2.id)!,
            version: row.read(documentsV2.ver)!,
          ),
        )
        .getSingleOrNull();
  }

  @override
  Future<void> save(DocumentWithAuthorsEntity entity) => saveAll([entity]);

  @override
  Future<void> saveAll(List<DocumentWithAuthorsEntity> entries) async {
    if (entries.isEmpty) return;

    final docs = entries.map((e) => e.doc);
    final authors = entries.map((e) => e.authors).flattened;

    await batch((batch) {
      batch.insertAll(
        documentsV2,
        docs,
        mode: InsertMode.insertOrIgnore,
      );

      if (authors.isNotEmpty) {
        batch.insertAll(
          documentAuthors,
          authors,
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  @override
  Stream<List<DocumentEntityV2>> watchDocuments({
    String? id,
    DocumentType? type,
    CampaignFilters? filters,
    bool latestOnly = false,
    int limit = 200,
    int offset = 0,
  }) {
    return _queryDocuments(
      id: id,
      type: type,
      filters: filters,
      latestOnly: latestOnly,
      limit: limit,
      offset: offset,
    ).watch();
  }

  SimpleSelectStatement<$DocumentsV2Table, DocumentEntityV2> _queryDocuments({
    String? id,
    DocumentType? type,
    CampaignFilters? filters,
    required bool latestOnly,
    required int limit,
    required int offset,
  }) {
    final effectiveLimit = limit.clamp(0, 999);

    final query = select(documentsV2);

    if (id != null) {
      query.where((tbl) => tbl.id.equals(id));
    }

    if (filters != null) {
      query.where((tbl) => tbl.categoryId.isIn(filters.categoriesIds));
    }

    if (type != null) {
      query.where((tbl) => tbl.type.equalsValue(type));
    }

    if (latestOnly) {
      final inner = alias(documentsV2, 'inner');

      query.where((tbl) {
        final maxCreatedAt = subqueryExpression<DateTime>(
          selectOnly(inner)
            ..addColumns([inner.createdAt.max()])
            ..where(inner.id.equalsExp(tbl.id)),
        );
        return tbl.createdAt.equalsExp(maxCreatedAt);
      });
    }

    query.limit(effectiveLimit, offset: offset);

    return query;
  }
}
