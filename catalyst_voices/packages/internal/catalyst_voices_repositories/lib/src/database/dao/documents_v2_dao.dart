import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:drift/drift.dart';

abstract interface class DocumentsV2Dao {
  /// Returns the total number of documents in the table.
  Future<int> count();

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

  /// Retrieves a document by its reference.
  ///
  /// If [ref] is exact (has version), returns the specific version.
  /// If loose (no version), returns the latest version by createdAt.
  /// Returns null if no matching document is found.
  Future<DocumentEntityV2?> getDocument(DocumentRef ref);

  /// Saves a single document, ignoring if it conflicts on {id, ver}.
  ///
  /// Delegates to [saveAll] for consistent conflict handling and reuse.
  Future<void> save(DocumentEntityV2 entity);

  /// Saves multiple documents in a batch operation, ignoring conflicts.
  ///
  /// [entries] is a list of DocumentEntity instances.
  /// Uses insertOrIgnore to skip on primary key conflicts ({id, ver}).
  Future<void> saveAll(List<DocumentEntityV2> entries);
}

@DriftAccessor(
  tables: [
    DocumentsV2,
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
  Future<bool> exists(DocumentRef ref) {
    final query = selectOnly(documentsV2)
      ..addColumns([const Constant(1)])
      ..where(documentsV2.id.equals(ref.id))
      ..limit(1);

    if (ref.isExact) {
      query.where((documentsV2.ver.equals(ref.version!)));
    }

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
  Future<DocumentEntityV2?> getDocument(DocumentRef ref) {
    final query = select(documentsV2)..where((tbl) => tbl.id.equals(ref.id));

    if (ref.isExact) {
      query.where((tbl) => tbl.ver.equals(ref.version!));
    } else {
      query
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
        ..limit(1);
    }

    return query.getSingleOrNull();
  }

  @override
  Future<void> saveAll(List<DocumentEntityV2> entries) async {
    if (entries.isEmpty) return;

    await batch((batch) {
      batch.insertAll(
        documentsV2,
        entries,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  @override
  Future<void> save(DocumentEntityV2 entity) => saveAll([entity]);
}
