import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/typedefs.dart';
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
  Future<List<DocumentEntity>> queryAll();

  /// Returns all known document refs.
  Future<List<SignedDocumentRef>> queryAllRefs();

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
    CatalystId? catalystId,
  });

  /// Watches for new comments that are reference by ref.
  Stream<int> watchCount({
    required DocumentRef ref,
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
  Future<List<DocumentEntity>> queryAll() {
    return select(documents).get();
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
  Future<List<DocumentEntity>> queryVersionsOfId({required String id}) {
    final query = select(documents)
      ..where((tbl) => _filterRef(tbl, SignedDocumentRef(id: id)))
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

  @override
  Stream<List<DocumentEntity>> watchAll({
    bool unique = false,
    int? limit,
    DocumentType? type,
    CatalystId? catalystId,
  }) {
    final query = select(documents);

    if (type != null) {
      query.where((doc) => doc.type.equals(type.uuid));
    }
    if (catalystId != null) {
      query.where(
        (doc) => CustomExpression<bool>(
          "json_extract(metadata, '\$.signers') LIKE '%$catalystId%'",
        ),
      );
    }

    return query.watch().map((documents) {
      if (unique) {
        // Group by document ID and take latest version
        final uniqueDocs = documents
            .groupListsBy((doc) => '${doc.idHi}-${doc.idLo}')
            .values
            .map(
              (versions) => versions.reduce((a, b) {
                // Compare versions (higher version wins)
                final compareHi = b.verHi.compareTo(a.verHi);
                if (compareHi != 0) return compareHi > 0 ? b : a;
                return b.verLo.compareTo(a.verLo) > 0 ? b : a;
              }),
            )
            .toList()
          ..sort((a, b) {
            // Sort by version descending
            final compareHi = b.verHi.compareTo(a.verHi);
            if (compareHi != 0) return compareHi;
            return b.verLo.compareTo(a.verLo);
          });

        if (limit != null) {
          return uniqueDocs.take(limit).toList();
        }
        return uniqueDocs;
      }

      if (limit != null) {
        return documents.take(limit).toList();
      }
      return documents;
    });
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

  bool _entitiesEquals(DocumentEntity? previous, DocumentEntity? next) {
    final previousId = (previous?.idHi, previous?.idLo);
    final nextId = (next?.idHi, next?.idLo);

    final previousVer = (previous?.verHi, previous?.verLo);
    final nextVer = (next?.verHi, next?.verLo);

    return previousId == nextId && previousVer == nextVer;
  }

  Expression<bool> _filterRef($DocumentsTable row, DocumentRef ref) {
    final id = UuidHiLo.from(ref.id);
    final ver = UuidHiLo.fromNullable(ref.version);

    return Expression.and([
      row.idHi.equals(id.high),
      row.idLo.equals(id.low),
      if (ver != null) ...[
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
