import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/typedefs.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';
import 'package:flutter/foundation.dart';

/// Exposes only public operation on documents, and related, tables.
abstract interface class DocumentsDao {
  /// Counts documents matching required [ref] id and optional [ref] ver.
  ///
  /// If [ref] is null counts all documents.
  ///
  /// If [ref] ver is not specified it will return count of all version
  /// matching [ref] id.
  Future<int> count({DocumentRef? ref});

  /// Counts unique documents. All versions of same document are counted as 1.
  Future<int> countDocuments();

  @visibleForTesting
  Future<int> countDocumentsMetadata();

  /// Counts documents of specified [type]
  /// that reference a given document [ref].
  ///
  /// [ref] is the reference to the parent document being referenced
  /// [type] is the type of documents to count (e.g., comments, reactions, etc.)
  ///
  /// Returns the count of documents matching both the type and reference.
  Future<int> countRefDocumentByType({
    required DocumentRef ref,
    required DocumentType type,
  });

  /// Deletes all documents. Cascades to metadata.
  Future<void> deleteAll();

  /// If version is specified in [ref] returns this version or null.
  /// Returns newest version with matching id or null of none found.
  Future<DocumentEntity?> query({required DocumentRef ref});

  /// Returns all entities. If same document have different versions
  /// all will be returned.
  Future<List<DocumentEntity>> queryAll({DocumentType? type});

  /// Returns all known document refs.
  Future<List<SignedDocumentRef>> queryAllRefs();

  /// Returns document with matching refTo and type.
  /// It return only lates version of document matching [refTo]
  Future<DocumentEntity?> queryRefToDocumentData({
    required DocumentRef refTo,
    DocumentType? type,
  });

  /// Returns a list of version of ref object.
  /// Can be used to get versions count.
  Future<List<DocumentEntity>> queryVersionsOfId({required String id});

  /// Inserts all documents and metadata. On conflicts ignores duplicates.
  Future<void> saveAll(
    Iterable<DocumentEntityWithMetadata> documentsWithMetadata,
  );

  /// Same as [query] but emits updates.
  Stream<DocumentEntity?> watch({required DocumentRef ref});

  /// Similar to [queryAll] but emits when new records are inserted or deleted.
  /// Returns all entities. If same document have different versions
  /// all will be returned unless [unique] is true.
  /// When [unique] is true, only latest versions of each document are returned.
  /// Optional [limit] parameter limits the number of returned documents.
  Stream<List<DocumentEntity>> watchAll({
    bool unique = false,
    int? limit,
    DocumentType? type,
    CatalystId? authorId,
    DocumentRef? refTo,
  });

  /// Watches for new comments that are reference by ref.
  Stream<int> watchCount({
    required DocumentRef ref,
    required DocumentType type,
  });

  Stream<DocumentEntity?> watchRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
  });
}

@DriftAccessor(
  tables: [
    Documents,
    DocumentsMetadata,
  ],
)
class DriftDocumentsDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDocumentsDaoMixin
    implements DocumentsDao {
  DriftDocumentsDao(super.attachedDatabase);

  @override
  Future<int> count({DocumentRef? ref}) {
    if (ref == null) {
      return documents.count().getSingle();
    } else {
      return documents.count(where: (row) => _filterRef(row, ref)).getSingle();
    }
  }

  @override
  Future<int> countDocuments() {
    final count = documents.idHi.count(distinct: true);

    final select = selectOnly(documents)
      ..addColumns([
        documents.idHi,
        documents.idLo,
        count,
      ]);

    return select
        .map((row) => row.read(count))
        .get()
        .then((count) => count.firstOrNull ?? 0);
  }

  @override
  Future<int> countDocumentsMetadata() {
    final count = documentsMetadata.verHi.count(distinct: true);

    final select = selectOnly(documentsMetadata)
      ..addColumns([
        documentsMetadata.verHi,
        documentsMetadata.verLo,
        count,
      ]);

    return select
        .map((row) => row.read(count))
        .get()
        .then((count) => count.firstOrNull ?? 0);
  }

  @override
  Future<int> countRefDocumentByType({
    required DocumentRef ref,
    required DocumentType type,
  }) async {
    final query = select(documents)
      ..where(
        (row) => Expression.and([
          row.metadata.jsonExtract<String>(r'$.type').equals(type.uuid),
          row.metadata.jsonExtract<String>(r'$.ref.id').equals(ref.id),
          if (ref.version != null)
            row.metadata
                .jsonExtract<String>(r'$.ref.version')
                .equals(ref.version!),
        ]),
      );

    final docs = await query.get();
    return docs.length;
  }

  @override
  Future<void> deleteAll() async {
    final deletedRows = await delete(documents).go();

    if (kDebugMode) {
      debugPrint('DocumentsDao: Deleted[$deletedRows] rows');
    }
  }

  @override
  Future<DocumentEntity?> query({required DocumentRef ref}) {
    return _selectRef(ref).get().then((value) => value.firstOrNull);
  }

  @override
  Future<List<DocumentEntity>> queryAll({DocumentType? type}) {
    final query = select(documents);
    if (type != null) {
      query.where((doc) => doc.type.equals(type.uuid));
    }

    return query.get();
  }

  @override
  Future<List<SignedDocumentRef>> queryAllRefs() {
    final select = selectOnly(documents)
      ..addColumns([
        documents.idHi,
        documents.idLo,
        documents.verHi,
        documents.verLo,
      ]);

    return select.map((row) {
      final id = UuidHiLo(
        high: row.read(documents.idHi)!,
        low: row.read(documents.idLo)!,
      );
      final version = UuidHiLo(
        high: row.read(documents.verHi)!,
        low: row.read(documents.verLo)!,
      );

      return SignedDocumentRef(id: id.uuid, version: version.uuid);
    }).get();
  }

  @override
  Future<DocumentEntity?> queryRefToDocumentData({
    required DocumentRef refTo,
    DocumentType? type,
  }) async {
    final query = select(documents)
      ..where(
        (row) => Expression.and([
          if (type != null) row.type.equals(type.uuid),
          row.metadata.jsonExtract<String>(r'$.ref.id').equals(refTo.id),
          if (refTo.version != null)
            row.metadata
                .jsonExtract<String>(r'$.ref.version')
                .equals(refTo.version!),
        ]),
      )
      ..orderBy([
        (u) => OrderingTerm.desc(u.verHi),
      ])
      ..limit(1);

    return query.getSingleOrNull();
  }

  @override
  Future<List<DocumentEntity>> queryVersionsOfId({required String id}) {
    final query = select(documents)
      ..where(
        (tbl) => _filterRef(
          tbl,
          SignedDocumentRef(id: id),
          filterVersion: false,
        ),
      )
      ..orderBy([
        (u) => OrderingTerm.desc(u.verHi),
      ]);

    return query.get();
  }

  @override
  Future<void> saveAll(
    Iterable<DocumentEntityWithMetadata> documentsWithMetadata,
  ) async {
    final documents = documentsWithMetadata.map((e) => e.document);
    final metadata = documentsWithMetadata.expand((e) => e.metadata);

    await batch((batch) {
      batch
        ..insertAll(
          this.documents,
          documents,
          mode: InsertMode.insertOrIgnore,
        )
        ..insertAll(
          documentsMetadata,
          metadata,
          mode: InsertMode.insertOrIgnore,
        );
    });
  }

  @override
  Stream<DocumentEntity?> watch({required DocumentRef ref}) {
    return _selectRef(ref)
        .watch()
        .map((event) => event.firstOrNull)
        .distinct(_entitiesEquals);
  }

  /// When [unique] is true, only latest versions of each document are returned.
  @override
  Stream<List<DocumentEntity>> watchAll({
    bool unique = false,
    int? limit,
    DocumentType? type,
    CatalystId? authorId,
    DocumentRef? refTo,
  }) {
    final query = select(documents);

    if (type != null) {
      query.where((doc) => doc.type.equals(type.uuid));
    }
    if (authorId != null) {
      final searchId = authorId.toSignificant().toUri().toStringWithoutScheme();

      query.where(
        (doc) => CustomExpression<bool>(
          "json_extract(metadata, '\$.authors') LIKE '%$searchId%'",
        ),
      );
    }
    if (refTo != null) {
      query.where(
        (row) => Expression.and([
          row.metadata.jsonExtract<String>(r'$.ref.id').equals(refTo.id),
          if (refTo.version != null)
            row.metadata
                .jsonExtract<String>(r'$.ref.version')
                .equals(refTo.version!),
        ]),
      );
    }

    query.orderBy([
      (t) => OrderingTerm(
            expression: t.verHi,
            mode: OrderingMode.desc,
          ),
    ]);

    if (unique) {
      return query.watch().map((list) {
        final latestVersions = <String, DocumentEntity>{};
        for (final entity in list) {
          final id = '${entity.idHi}_${entity.idLo}';
          if (!latestVersions.containsKey(id)) {
            latestVersions[id] = entity;
          }
        }
        if (limit != null) {
          return latestVersions.values.toList().take(limit).toList();
        }
        return latestVersions.values.toList();
      });
    }

    if (limit != null) {
      query.limit(limit);
    }
    return query.watch();
  }

  @override
  Stream<int> watchCount({
    required DocumentRef ref,
    required DocumentType type,
  }) {
    final query = select(documents)
      ..where(
        (row) {
          return Expression.and([
            row.metadata.jsonExtract<String>(r'$.type').equals(type.uuid),
            row.metadata.jsonExtract<String>(r'$.ref.id').equals(ref.id),
            if (ref.version != null)
              row.metadata
                  .jsonExtract<String>(r'$.ref.version')
                  .equals(ref.version!),
          ]);
        },
      );

    return query.watch().map((comments) => comments.length).distinct();
  }

  @override
  Stream<DocumentEntity?> watchRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
  }) {
    final query = select(documents)
      ..where(
        (row) => Expression.and([
          row.metadata.jsonExtract<String>(r'$.type').equals(type.uuid),
          row.metadata.jsonExtract<String>(r'$.ref.id').equals(refTo.id),
          if (refTo.version != null)
            row.metadata
                .jsonExtract<String>(r'$.ref.version')
                .equals(refTo.version!),
        ]),
      )
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.verHi,
              mode: OrderingMode.desc,
            ),
      ]);

    return query
        .watch()
        .map((event) => event.firstOrNull)
        .distinct(_entitiesEquals);
  }

  bool _entitiesEquals(DocumentEntity? previous, DocumentEntity? next) {
    final previousId = (previous?.idHi, previous?.idLo);
    final nextId = (next?.idHi, next?.idLo);

    final previousVer = (previous?.verHi, previous?.verLo);
    final nextVer = (next?.verHi, next?.verLo);

    return previousId == nextId && previousVer == nextVer;
  }

  Expression<bool> _filterRef(
    $DocumentsTable row,
    DocumentRef ref, {
    bool filterVersion = true,
  }) {
    final id = UuidHiLo.from(ref.id);
    final ver = UuidHiLo.fromNullable(ref.version);

    return Expression.and([
      row.idHi.equals(id.high),
      row.idLo.equals(id.low),
      if (ver != null && filterVersion) ...[
        row.verHi.equals(ver.high),
        row.verLo.equals(ver.low),
      ],
    ]);
  }

  SimpleSelectStatement<$DocumentsTable, DocumentEntity> _selectRef(
    DocumentRef ref,
  ) {
    return select(documents)
      ..where((tbl) => _filterRef(tbl, ref))
      ..orderBy([
        (u) => OrderingTerm.desc(u.verHi),
      ])
      ..limit(1);
  }
}
