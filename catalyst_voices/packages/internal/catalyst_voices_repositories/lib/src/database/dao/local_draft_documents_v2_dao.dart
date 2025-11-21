import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/local_draft_documents_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.drift.dart';
import 'package:drift/drift.dart';

@DriftAccessor(
  tables: [
    LocalDocumentsDrafts,
  ],
)
class DriftLocalDraftDocumentsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftLocalDraftDocumentsV2DaoMixin
    implements LocalDraftDocumentsV2Dao {
  DriftLocalDraftDocumentsV2Dao(super.attachedDatabase);

  @override
  Future<int> count({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  }) {
    return _queryCount(type: type, ref: ref, refTo: refTo).getSingle().then((value) => value ?? 0);
  }

  @override
  Future<int> deleteWhere({
    DocumentRef? ref,
    List<DocumentType>? typeNotIn,
  }) {
    final query = delete(localDocumentsDrafts);

    if (typeNotIn != null) {
      query.where((tbl) => tbl.type.isNotInValues(typeNotIn));
    }

    return query.go();
  }

  @override
  Future<bool> exists(DocumentRef ref) {
    final query = selectOnly(localDocumentsDrafts)
      ..addColumns([const Constant(1)])
      ..where(localDocumentsDrafts.id.equals(ref.id));

    if (ref.isExact) {
      query.where(localDocumentsDrafts.ver.equals(ref.version!));
    }

    query.limit(1);

    return query.getSingleOrNull().then((result) => result != null);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs) async {
    if (refs.isEmpty) return [];

    final uniqueIds = refs.map((ref) => ref.id).toSet();

    // Single query: Fetch all (id, ver) for matching ids
    final query = selectOnly(localDocumentsDrafts)
      ..addColumns([localDocumentsDrafts.id, localDocumentsDrafts.ver])
      ..where(localDocumentsDrafts.id.isIn(uniqueIds));

    final rows = await query.map(
      (row) {
        final id = row.read(localDocumentsDrafts.id)!;
        final ver = row.read(localDocumentsDrafts.ver)!;
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
  Future<LocalDocumentDraftEntity?> getDocument({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  }) {
    return _queryDocument(type: type, ref: ref, refTo: refTo).getSingleOrNull();
  }

  @override
  Future<List<LocalDocumentDraftEntity>> getDocuments({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    CampaignFilters? filters,
    bool latestOnly = false,
    int limit = 200,
    int offset = 0,
  }) {
    return _queryDocuments(
      type: type,
      ref: ref,
      refTo: refTo,
      filters: filters,
      latestOnly: latestOnly,
      limit: limit,
      offset: offset,
    ).get();
  }

  @override
  Future<DocumentRef?> getLatestOf(DocumentRef ref) {
    final query = selectOnly(localDocumentsDrafts)
      ..addColumns([localDocumentsDrafts.id, localDocumentsDrafts.ver])
      ..where(localDocumentsDrafts.id.equals(ref.id))
      ..orderBy([OrderingTerm.desc(localDocumentsDrafts.createdAt)])
      ..limit(1);

    return query
        .map(
          (row) => DraftRef(
            id: row.read(localDocumentsDrafts.id)!,
            version: row.read(localDocumentsDrafts.ver),
          ),
        )
        .getSingleOrNull();
  }

  @override
  Future<void> saveAll(List<LocalDocumentDraftEntity> entries) async {
    await batch((batch) {
      batch.insertAll(
        localDocumentsDrafts,
        entries,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> updateContent({
    required DocumentRef ref,
    required DocumentDataContent content,
  }) async {
    final insertable = LocalDocumentsDraftsCompanion(content: Value(content));

    final query = update(localDocumentsDrafts)..where((tbl) => tbl.id.equals(ref.id));

    if (ref.isExact) {
      query.where((tbl) => tbl.ver.equals(ref.version!));
    }

    await query.write(insertable);
  }

  @override
  Stream<int> watchCount({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  }) {
    return _queryCount(type: type, ref: ref, refTo: refTo).watchSingle().map((value) => value ?? 0);
  }

  @override
  Stream<LocalDocumentDraftEntity?> watchDocument({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  }) {
    return _queryDocument(type: type, ref: ref, refTo: refTo).watchSingleOrNull();
  }

  @override
  Stream<List<LocalDocumentDraftEntity>> watchDocuments({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    CampaignFilters? filters,
    bool latestOnly = false,
    int limit = 200,
    int offset = 0,
  }) {
    return _queryDocuments(
      type: type,
      ref: ref,
      refTo: refTo,
      filters: filters,
      latestOnly: latestOnly,
      limit: limit,
      offset: offset,
    ).watch();
  }

  Selectable<int?> _queryCount({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  }) {
    final count = countAll();
    final query = selectOnly(localDocumentsDrafts)..addColumns([count]);

    if (type != null) {
      query.where(localDocumentsDrafts.type.equalsValue(type));
    }

    if (ref != null) {
      query.where(localDocumentsDrafts.id.equals(ref.id));

      if (ref.isExact) {
        query.where(localDocumentsDrafts.ver.equals(ref.version!));
      }
    }

    if (refTo != null) {
      query.where(localDocumentsDrafts.refId.equals(refTo.id));

      if (refTo.isExact) {
        query.where(localDocumentsDrafts.refVer.equals(refTo.version!));
      }
    }

    return query.map((row) => row.read(count));
  }

  Selectable<LocalDocumentDraftEntity> _queryDocument({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  }) {
    final query = select(localDocumentsDrafts);

    if (ref != null) {
      query.where((tbl) => tbl.id.equals(ref.id));

      if (ref.isExact) {
        query.where((tbl) => tbl.ver.equals(ref.version!));
      }
    }

    if (refTo != null) {
      query.where((tbl) => tbl.refId.equals(refTo.id));

      if (refTo.isExact) {
        query.where((tbl) => tbl.refVer.equals(refTo.version!));
      }
    }

    if (type != null) {
      query.where((tbl) => tbl.type.equalsValue(type));
    }

    query
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ])
      ..limit(1);

    return query;
  }

  SimpleSelectStatement<$LocalDocumentsDraftsTable, LocalDocumentDraftEntity> _queryDocuments({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    CampaignFilters? filters,
    required bool latestOnly,
    required int limit,
    required int offset,
  }) {
    final effectiveLimit = limit.clamp(0, 999);
    final query = select(localDocumentsDrafts);

    if (type != null) {
      query.where((tbl) => tbl.type.equalsValue(type));
    }

    if (ref != null) {
      query.where((tbl) => tbl.id.equals(ref.id));

      if (ref.isExact) {
        query.where((tbl) => tbl.ver.equals(ref.version!));
      }
    }

    if (refTo != null) {
      query.where((tbl) => tbl.refId.equals(refTo.id));

      if (refTo.isExact) {
        query.where((tbl) => tbl.refVer.equals(refTo.version!));
      }
    }

    if (filters != null) {
      query.where((tbl) => tbl.categoryId.isIn(filters.categoriesIds));
    }

    if (latestOnly && ref?.version == null) {
      final inner = alias(localDocumentsDrafts, 'inner');

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

/// This interface is very similar to [DocumentsV2Dao] so see methods explanation there.
abstract interface class LocalDraftDocumentsV2Dao {
  Future<int> count({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  Future<int> deleteWhere({
    DocumentRef? ref,
    List<DocumentType>? typeNotIn,
  });

  Future<bool> exists(DocumentRef ref);

  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs);

  Future<LocalDocumentDraftEntity?> getDocument({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  Future<List<LocalDocumentDraftEntity>> getDocuments({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    CampaignFilters? filters,
    bool latestOnly,
    int limit,
    int offset,
  });

  Future<DocumentRef?> getLatestOf(DocumentRef ref);

  Future<void> saveAll(List<LocalDocumentDraftEntity> entries);

  Future<void> updateContent({
    required DocumentRef ref,
    required DocumentDataContent content,
  });

  Stream<int> watchCount({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  Stream<LocalDocumentDraftEntity?> watchDocument({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  Stream<List<LocalDocumentDraftEntity>> watchDocuments({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    CampaignFilters? filters,
    bool latestOnly,
    int limit,
    int offset,
  });
}
