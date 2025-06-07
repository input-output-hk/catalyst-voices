import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/query/jsonb_expressions.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

/// Exposes only public operation on drafts, and related, tables.
abstract interface class DraftsDao {
  /// Counts drafts matching required [ref] id and optional [ref] ver.
  ///
  /// If ref is null it will count all drafts.
  ///
  /// If [ref] ver is not specified it will return count of all version
  /// matching [ref] id.
  Future<int> count({DocumentRef? ref});

  /// Deletes a document draft with [ref].
  ///
  /// If [ref] is null then all drafts are deleted.
  Future<void> deleteWhere({DraftRef ref});

  /// If version is specified in [ref] returns this version or null.
  /// Returns newest version with matching id or null of none found.
  Future<DocumentDraftEntity?> query({required DocumentRef ref});

  /// Returns all drafts
  Future<List<DocumentDraftEntity>> queryAll();

  /// Returns all known document drafts refs.
  Future<List<TypedDocumentRef>> queryAllTypedRefs();

  Future<DocumentDraftEntity?> queryLatest({
    CatalystId? authorId,
  });

  Future<List<DocumentDraftEntity>> queryVersionsOfId({required String id});

  /// Singular version of [saveAll]. Does not run in transaction.
  Future<void> save(DocumentDraftEntity draft);

  /// Inserts all drafts. On conflicts updates.
  Future<void> saveAll(Iterable<DocumentDraftEntity> drafts);

  /// Updates matching [ref] records with [content].
  ///
  /// Be aware that if version is not specified all version of [ref] id
  /// will be updated.
  Future<void> updateContent({
    required DraftRef ref,
    required DocumentDataContent content,
  });

  /// Same as [query] but emits updates.
  Stream<DocumentDraftEntity?> watch({required DocumentRef ref});

  Stream<List<DocumentDraftEntity>> watchAll({
    int? limit,
    DocumentType? type,
    CatalystId? authorId,
  });
}

@DriftAccessor(
  tables: [
    Drafts,
  ],
)
class DriftDraftsDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDraftsDaoMixin
    implements DraftsDao {
  DriftDraftsDao(super.attachedDatabase);

  @override
  Future<int> count({DocumentRef? ref}) {
    if (ref == null) {
      return drafts.count().getSingle();
    } else {
      return drafts.count(where: (row) => _filterRef(row, ref)).getSingle();
    }
  }

  @override
  Future<void> deleteWhere({DraftRef? ref}) async {
    if (ref == null) {
      await drafts.deleteAll();
    } else {
      await drafts.deleteWhere((row) => _filterRef(row, ref));
    }
  }

  @override
  Future<DocumentDraftEntity?> query({required DocumentRef ref}) {
    return _selectRef(ref).get().then((value) => value.firstOrNull);
  }

  @override
  Future<List<DocumentDraftEntity>> queryAll() {
    return select(drafts).get();
  }

  @override
  Future<List<TypedDocumentRef>> queryAllTypedRefs() {
    final select = selectOnly(drafts)
      ..addColumns([
        drafts.idHi,
        drafts.idLo,
        drafts.verHi,
        drafts.verLo,
        drafts.type,
      ]);

    return select.map((row) {
      final id = UuidHiLo(
        high: row.read(drafts.idHi)!,
        low: row.read(drafts.idLo)!,
      );
      final version = UuidHiLo(
        high: row.read(drafts.verHi)!,
        low: row.read(drafts.verLo)!,
      );
      final ref = DraftRef(id: id.uuid, version: version.uuid);
      final type = row.readWithConverter(drafts.type)!;

      return TypedDocumentRef(ref: ref, type: type);
    }).get();
  }

  @override
  Future<DocumentDraftEntity?> queryLatest({
    CatalystId? authorId,
  }) {
    final query = select(drafts)
      ..orderBy([(t) => OrderingTerm.desc(t.verHi)])
      ..limit(1);

    if (authorId != null) {
      query.where((tbl) => tbl.metadata.isAuthor(authorId));
    }

    return query.getSingleOrNull();
  }

  @override
  Future<List<DocumentDraftEntity>> queryVersionsOfId({required String id}) {
    final query = select(drafts)
      ..where(
        (tbl) => _filterRef(
          tbl,
          DraftRef(id: id),
          filterVersion: false,
        ),
      )
      ..orderBy([
        (u) => OrderingTerm.desc(u.verHi),
      ]);

    return query.get();
  }

  @override
  Future<void> save(DocumentDraftEntity draft) async {
    await into(drafts).insert(draft, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> saveAll(Iterable<DocumentDraftEntity> drafts) async {
    await batch((batch) {
      batch.insertAll(
        this.drafts,
        drafts,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> updateContent({
    required DocumentRef ref,
    required DocumentDataContent content,
  }) async {
    final insertable = DraftsCompanion(
      content: Value(content),
      title: content.title != null ? Value(content.title!) : const Value.absent(),
    );
    final query = update(drafts)..where((tbl) => _filterRef(tbl, ref));

    final updatedRows = await query.write(insertable);

    if (kDebugMode) {
      debugPrint('DraftsDao: Updated[$updatedRows] $ref rows');
    }
  }

  @override
  Stream<DocumentDraftEntity?> watch({required DocumentRef ref}) {
    return _selectRef(ref).watch().map((event) => event.firstOrNull);
  }

  @override
  Stream<List<DocumentDraftEntity>> watchAll({
    int? limit,
    DocumentType? type,
    CatalystId? authorId,
  }) {
    final query = select(drafts);

    if (type != null) {
      query.where((doc) => doc.type.equalsValue(type));
    }
    if (authorId != null) {
      final searchId = authorId.toSignificant().toUri().toStringWithoutScheme();

      query.where(
        (doc) => CustomExpression<bool>("json_extract(metadata, '\$.authors') LIKE '%$searchId%'"),
      );
    }

    query.orderBy([
      (t) => OrderingTerm(
            expression: t.verHi,
            mode: OrderingMode.desc,
          ),
    ]);

    if (limit != null) {
      query.limit(limit);
    }

    return query.watch();
  }

  Expression<bool> _filterRef(
    $DraftsTable row,
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

  SimpleSelectStatement<$DraftsTable, DocumentDraftEntity> _selectRef(
    DocumentRef ref,
  ) {
    return select(drafts)
      ..where((tbl) => _filterRef(tbl, ref))
      ..orderBy([
        (u) => OrderingTerm.desc(u.verHi),
      ])
      ..limit(1);
  }
}
