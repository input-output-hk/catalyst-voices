import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.drift.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

/// Exposes only public operation on drafts, and related, tables.
abstract interface class DraftsDao {
  /// Returns all drafts
  Future<List<DocumentDraftEntity>> queryAll();

  /// Returns all known document drafts refs.
  Future<List<DraftRef>> queryAllRefs();

  /// If version is specified in [ref] returns this version or null.
  /// Returns newest version with matching id or null of none found.
  Future<DocumentDraftEntity?> query({required DocumentRef ref});

  /// Same as [query] but emits updates.
  Stream<DocumentDraftEntity?> watch({required DocumentRef ref});

  /// Counts unique drafts. All versions of same document are counted as 1.
  Future<int> countAll();

  /// Counts drafts matching required [ref] id and optional [ref] ver.
  ///
  /// If [ref] ver is not specified it will return count of all version
  /// matching [ref] id.
  Future<int> count({required DocumentRef ref});

  /// Inserts all drafts. On conflicts updates.
  Future<void> saveAll(Iterable<DocumentDraftEntity> drafts);

  /// Singular version of [saveAll]. Does not run in transaction.
  Future<void> save(DocumentDraftEntity draft);

  /// Updates matching [ref] records with [content].
  ///
  /// Be aware that if version is not specified all version of [ref] id
  /// will be updated.
  Future<void> updateContent({
    required DocumentRef ref,
    required DocumentDataContent content,
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
  Future<List<DocumentDraftEntity>> queryAll() {
    return select(drafts).get();
  }

  @override
  Future<List<DraftRef>> queryAllRefs() {
    final select = selectOnly(drafts)
      ..addColumns([
        drafts.idHi,
        drafts.idLo,
        drafts.verHi,
        drafts.verLo,
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

      return DraftRef(id: id.uuid, version: version.uuid);
    }).get();
  }

  @override
  Future<DocumentDraftEntity?> query({required DocumentRef ref}) {
    return _selectRef(ref).get().then((value) => value.firstOrNull);
  }

  @override
  Stream<DocumentDraftEntity?> watch({required DocumentRef ref}) {
    return _selectRef(ref).watch().map((event) => event.firstOrNull);
  }

  @override
  Future<int> countAll() {
    return drafts.count().getSingle();
  }

  @override
  Future<int> count({required DocumentRef ref}) {
    return drafts.count(where: (row) => _filterRef(row, ref)).getSingle();
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
  Future<void> save(DocumentDraftEntity draft) async {
    await into(drafts).insert(draft, mode: InsertMode.insertOrReplace);
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
}
