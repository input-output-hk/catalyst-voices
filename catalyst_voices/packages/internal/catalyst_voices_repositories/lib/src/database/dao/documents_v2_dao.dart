import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide DocumentParameters;
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_composite_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_artifacts.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_collaborators.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_parameters.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

abstract interface class DocumentsV2Dao {
  /// Counts the number of documents matching the provided filters.
  ///
  /// [type] filters by the document type (e.g., proposal, comment).
  /// [id] filters by the document's own identity.
  ///   - If [DocumentRef.isExact], counts matches for that specific version.
  ///   - If [DocumentRef.isLoose], counts all versions of that document ID.
  /// [referencing] filters documents that *reference* the given target.
  ///   - Example: Count all comments ([type]=comment) that point to proposal X ([referencing]=X).
  Future<int> count({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  });

  /// Deletes documents from the database, preserving those with types in [excludeTypes].
  ///
  /// If [excludeTypes] is null or empty, this may delete *all* documents (implementation dependent).
  /// Typically used for cache invalidation or cleaning up old data while keeping
  /// certain important types (e.g. keeping local drafts or templates).
  ///
  /// Returns the number of deleted rows.
  Future<int> deleteWhere({
    List<DocumentType>? excludeTypes,
  });

  /// Checks if a document exists in the database.
  ///
  /// [id] determines the scope of the check:
  /// - [SignedDocumentRef.exact]: Returns true only if that specific version exists.
  /// - [SignedDocumentRef.loose]: Returns true if *any* version of that ID exists.
  Future<bool> exists(DocumentRef id);

  /// Filters a list of references, returning only those that exist in the database.
  ///
  /// This is useful for bulk validation.
  /// - For exact refs, it checks for exact matches.
  /// - For loose refs, it checks if any version of the ID exists.
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> ids);

  /// Retrieves a single document matching the criteria.
  ///
  /// If multiple documents match (e.g. querying by loose ref or type only),
  /// the one with the latest [DocumentEntityV2.createdAt] timestamp is returned.
  ///
  /// [author] - If provided, filters for documents where the specified [CatalystId]
  /// is listed as an author of that specific version.
  ///
  /// [originalAuthor] - If provided, filters for documents where the specified [CatalystId]
  /// is the author of the *first version* (where id == ver).
  ///
  /// Returns `null` if no matching document is found.
  Future<DocumentEntityV2?> getDocument({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    DocumentRef? parameter,
    CatalystId? author,
    CatalystId? originalAuthor,
  });

  /// Retrieves only the artifact of a signed document.
  ///
  /// Returns `null` if no matching document is found.
  Future<DocumentArtifact?> getDocumentArtifact(DocumentRef id);

  /// Retrieves a list of documents matching the criteria with pagination.
  ///
  /// [latestOnly] - If `true`, only the most recent version (by [DocumentEntityV2.createdAt])
  /// of each unique document ID is returned. If `false`, all versions are returned.
  /// [limit] - The maximum number of documents to return (clamped to 999).
  /// [offset] - The number of documents to skip.
  ///
  /// Note: Ensure the implementation applies a deterministic `orderBy` clause
  /// (usually `createdAt` DESC) to ensure stable pagination.
  Future<List<DocumentEntityV2>> getDocuments({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CampaignFilters? campaign,
    bool latestOnly,
    int limit,
    int offset,
  });

  /// Finds the latest version of a document given a reference.
  ///
  /// Even if [id] points to an older version (exact), this method will find
  /// the version with the newest [DocumentEntityV2.createdAt] timestamp for that [DocumentRef.id].
  ///
  /// Returns `null` if the document ID does not exist in the database.
  Future<DocumentRef?> getLatestOf(DocumentRef id);

  /// Saves a single document and its associated authors.
  ///
  /// This is a convenience wrapper around [saveAll].
  Future<void> save(DocumentCompositeEntity entity);

  /// Saves multiple documents and their authors in a single transaction.
  ///
  /// Uses `INSERT OR IGNORE` conflict resolution. If a document with the same
  /// `id` and `ver` already exists, the new record is ignored.
  Future<void> saveAll(List<DocumentCompositeEntity> entries);

  /// Watches for changes and emits the count of documents matching the filters.
  ///
  /// Emits a new value whenever the underlying tables change in a way that
  /// affects the count.
  Stream<int> watchCount({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  });

  /// Watches for changes to a specific document query.
  ///
  /// Emits the updated document (or null) whenever a matching record is
  /// inserted, updated, or deleted.
  Stream<DocumentEntityV2?> watchDocument({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CatalystId? author,
    CatalystId? originalAuthor,
  });

  /// Watches for changes and emits a list of documents.
  ///
  /// This stream automatically updates when new documents are synced or
  /// existing ones are modified.
  ///
  /// Note: Large limits or complex filters in a watch stream can impact performance
  /// as the query is re-run on every write to the `documents_v2` table.
  Stream<List<DocumentEntityV2>> watchDocuments({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CampaignFilters? campaign,
    bool latestOnly,
    int limit,
    int offset,
  });
}

@DriftAccessor(
  tables: [
    DocumentsV2,
    DocumentAuthors,
    DocumentArtifacts,
    DocumentParameters,
    DocumentCollaborators,
  ],
)
class DriftDocumentsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDocumentsV2DaoMixin
    implements DocumentsV2Dao {
  DriftDocumentsV2Dao(super.attachedDatabase);

  @override
  Future<int> count({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  }) {
    return _queryCount(
      type: type,
      id: id,
      referencing: referencing,
    ).getSingle().then((value) => value ?? 0);
  }

  @override
  Future<int> deleteWhere({
    List<DocumentType>? excludeTypes,
  }) {
    final query = delete(documentsV2);

    if (excludeTypes != null) {
      query.where((tbl) => tbl.type.isNotInValues(excludeTypes));
    }

    return query.go();
  }

  @override
  Future<bool> exists(DocumentRef id) {
    final query = selectOnly(documentsV2)
      ..addColumns([const Constant(1)])
      ..where(documentsV2.id.equals(id.id));

    if (id.isExact) {
      query.where(documentsV2.ver.equals(id.ver!));
    }

    query.limit(1);

    return query.getSingleOrNull().then((result) => result != null);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> ids) async {
    if (ids.isEmpty) return [];

    final uniqueIds = ids.map((ref) => ref.id).toSet();

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

    return ids.where((ref) {
      final vers = idToVers[ref.id];
      if (vers == null || vers.isEmpty) return false;

      return !ref.isExact || vers.contains(ref.ver);
    }).toList();
  }

  @override
  Future<DocumentEntityV2?> getDocument({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    DocumentRef? parameter,
    CatalystId? author,
    CatalystId? originalAuthor,
  }) {
    return _queryDocument(
      type: type,
      id: id,
      referencing: referencing,
      parameter: parameter,
      author: author,
      originalAuthor: originalAuthor,
    ).getSingleOrNull();
  }

  @override
  Future<DocumentArtifact?> getDocumentArtifact(DocumentRef id) {
    final query = selectOnly(documentArtifacts)
      ..addColumns([documentArtifacts.data])
      ..where(documentArtifacts.id.equals(id.id));

    if (id.isExact) {
      query.where(documentArtifacts.ver.equals(id.ver!));
    } else {
      // If loose ref, get artifact for latest version of that ID.
      query
        ..orderBy([OrderingTerm.desc(documentArtifacts.ver)])
        ..limit(1);
    }

    return query
        .map((row) => row.read(documentArtifacts.data))
        .getSingleOrNull()
        .then((value) => value != null ? DocumentArtifact(value) : null);
  }

  @override
  Future<List<DocumentEntityV2>> getDocuments({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CampaignFilters? campaign,
    bool latestOnly = false,
    int limit = 200,
    int offset = 0,
  }) {
    return _queryDocuments(
      type: type,
      id: id,
      referencing: referencing,
      campaign: campaign,
      latestOnly: latestOnly,
      limit: limit,
      offset: offset,
    ).get();
  }

  @override
  Future<DocumentRef?> getLatestOf(DocumentRef id) {
    final query = selectOnly(documentsV2)
      ..addColumns([documentsV2.id, documentsV2.ver])
      ..where(documentsV2.id.equals(id.id))
      ..orderBy([OrderingTerm.desc(documentsV2.createdAt)])
      ..limit(1);

    return query
        .map(
          (row) => SignedDocumentRef.exact(
            id: row.read(documentsV2.id)!,
            ver: row.read(documentsV2.ver)!,
          ),
        )
        .getSingleOrNull();
  }

  @override
  Future<void> save(DocumentCompositeEntity entity) => saveAll([entity]);

  @override
  Future<void> saveAll(List<DocumentCompositeEntity> entries) async {
    if (entries.isEmpty) return;

    final docs = entries.map((e) => e.doc);
    final authors = entries.map((e) => e.authors).flattened;
    final artifacts = entries.map((e) => e.artifact);
    final parameters = entries.map((e) => e.parameters).flattened;
    final collaborators = entries.map((e) => e.collaborators).flattened;

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
      if (artifacts.isNotEmpty) {
        batch.insertAll(
          documentArtifacts,
          artifacts,
          mode: InsertMode.insertOrIgnore,
        );
      }
      if (parameters.isNotEmpty) {
        batch.insertAll(
          documentParameters,
          parameters,
          mode: InsertMode.insertOrIgnore,
        );
      }
      if (collaborators.isNotEmpty) {
        batch.insertAll(
          documentCollaborators,
          collaborators,
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  @override
  Stream<int> watchCount({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  }) {
    return _queryCount(
      type: type,
      id: id,
      referencing: referencing,
    ).watchSingle().map((value) => value ?? 0);
  }

  @override
  Stream<DocumentEntityV2?> watchDocument({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CatalystId? author,
    CatalystId? originalAuthor,
  }) {
    return _queryDocument(
      type: type,
      id: id,
      referencing: referencing,
      author: author,
      originalAuthor: originalAuthor,
    ).watchSingleOrNull();
  }

  @override
  Stream<List<DocumentEntityV2>> watchDocuments({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CampaignFilters? campaign,
    bool latestOnly = false,
    int limit = 200,
    int offset = 0,
  }) {
    return _queryDocuments(
      type: type,
      id: id,
      referencing: referencing,
      campaign: campaign,
      latestOnly: latestOnly,
      limit: limit,
      offset: offset,
    ).watch();
  }

  Selectable<int?> _queryCount({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  }) {
    final count = countAll();
    final query = selectOnly(documentsV2)..addColumns([count]);

    if (type != null) {
      query.where(documentsV2.type.equalsValue(type));
    }

    if (id != null) {
      query.where(documentsV2.id.equals(id.id));

      if (id.isExact) {
        query.where(documentsV2.ver.equals(id.ver!));
      }
    }

    if (referencing != null) {
      query.where(documentsV2.refId.equals(referencing.id));

      if (referencing.isExact) {
        query.where(documentsV2.refVer.equals(referencing.ver!));
      }
    }

    return query.map((row) => row.read(count));
  }

  Selectable<DocumentEntityV2> _queryDocument({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    DocumentRef? parameter,
    CatalystId? author,
    CatalystId? originalAuthor,
  }) {
    final query = select(documentsV2);

    if (id != null) {
      query.where((tbl) => tbl.id.equals(id.id));

      if (id.isExact) {
        query.where((tbl) => tbl.ver.equals(id.ver!));
      }
    }

    if (referencing != null) {
      query.where((tbl) => tbl.refId.equals(referencing.id));

      if (referencing.isExact) {
        query.where((tbl) => tbl.refVer.equals(referencing.ver!));
      }
    }

    if (parameter != null) {
      query.where((tbl) {
        final dp = alias(documentParameters, 'dp');
        final dpQuery = selectOnly(dp)
          ..addColumns([const Constant(1)])
          ..where(dp.documentId.equalsExp(tbl.id))
          ..where(dp.documentVer.equalsExp(tbl.ver))
          ..where(dp.id.equals(parameter.id));

        if (parameter.isExact) {
          dpQuery.where(dp.ver.equals(parameter.ver!));
        }

        return existsQuery(dpQuery);
      });
    }

    if (type != null) {
      query.where((tbl) => tbl.type.equalsValue(type));
    }

    if (author != null) {
      final significant = author.toSignificant();
      query.where((tbl) {
        final authorQuery = selectOnly(documentAuthors)
          ..addColumns([const Constant(1)])
          ..where(documentAuthors.documentId.equalsExp(tbl.id))
          ..where(documentAuthors.documentVer.equalsExp(tbl.ver))
          ..where(documentAuthors.accountSignificantId.equals(significant.toUri().toString()));
        return existsQuery(authorQuery);
      });
    }

    if (originalAuthor != null) {
      final significant = originalAuthor.toSignificant();
      query.where((tbl) {
        final originalAuthorQuery = selectOnly(documentAuthors)
          ..addColumns([const Constant(1)])
          ..where(documentAuthors.documentId.equalsExp(tbl.id))
          /// Check against tbl.id to target the first version (where id == ver)
          ..where(documentAuthors.documentVer.equalsExp(tbl.id))
          ..where(documentAuthors.accountSignificantId.equals(significant.toUri().toString()));
        return existsQuery(originalAuthorQuery);
      });
    }

    query
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ])
      ..limit(1);

    return query;
  }

  SimpleSelectStatement<$DocumentsV2Table, DocumentEntityV2> _queryDocuments({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CampaignFilters? campaign,
    required bool latestOnly,
    required int limit,
    required int offset,
  }) {
    final effectiveLimit = limit.clamp(0, 999);
    final query = select(documentsV2);

    if (type != null) {
      query.where((tbl) => tbl.type.equalsValue(type));
    }

    if (id != null) {
      query.where((tbl) => tbl.id.equals(id.id));

      if (id.isExact) {
        query.where((tbl) => tbl.ver.equals(id.ver!));
      }
    }

    if (referencing != null) {
      query.where((tbl) => tbl.refId.equals(referencing.id));

      if (referencing.isExact) {
        query.where((tbl) => tbl.refVer.equals(referencing.ver!));
      }
    }

    if (campaign != null) {
      query.where((tbl) {
        final dp = alias(documentParameters, 'dp');
        return existsQuery(
          selectOnly(dp)
            ..addColumns([const Constant(1)])
            ..where(dp.documentId.equalsExp(tbl.id))
            ..where(dp.documentVer.equalsExp(tbl.ver))
            ..where(dp.id.isIn(campaign.categoriesIds)),
        );
      });
    }

    if (latestOnly && id?.ver == null) {
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

    query
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(effectiveLimit, offset: offset);

    return query;
  }
}
