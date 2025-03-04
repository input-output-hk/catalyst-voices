import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.drift.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

/// Exposes only public operation on drafts, and related, tables.
abstract interface class DraftsDao {
  /// Counts drafts matching required [ref] id and optional [ref] ver.
  ///
  /// If [ref] ver is not specified it will return count of all version
  /// matching [ref] id.
  Future<int> count({required DocumentRef ref});

  /// Counts unique drafts. All versions of same document are counted as 1.
  Future<int> countAll();

  /// Deletes a document draft with [ref].
  ///
  /// If [ref] is null then all drafts are deleted.
  Future<void> deleteWhere({DraftRef ref});

  /// If version is specified in [ref] returns this version or null.
  /// Returns newest version with matching id or null of none found.
  Future<DocumentDraftEntity?> query({required DocumentRef ref});

  /// Returns all drafts
  Future<List<DocumentDraftEntity>> queryAll();

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
  Future<int> count({required DocumentRef ref}) {
    return drafts.count(where: (row) => _filterRef(row, ref)).getSingle();
  }

  @override
  Future<int> countAll() {
    return drafts.count().getSingle();
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
    final insertable = DraftsCompanion(content: Value(content));
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

  Expression<bool> _filterRef($DraftsTable row, DocumentRef ref) {
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
