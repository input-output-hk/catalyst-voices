import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Base interface to interact with locally document data.
abstract interface class DocumentDataLocalSource implements DocumentDataSource {
  Future<int> count({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  Future<int> delete({
    List<DocumentType>? typeNotIn,
  });

  Future<bool> exists({required DocumentRef ref});

  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs);

  @override
  Future<DocumentData?> get({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  Future<List<DocumentData>> getAll({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    bool latestOnly,
    int limit,
    int offset,
  });

  Future<void> save({required DocumentData data});

  Future<void> saveAll(Iterable<DocumentData> data);

  Stream<DocumentData?> watch({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });

  Stream<List<DocumentData>> watchAll({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    bool latestOnly,
    int limit,
    int offset,
  });

  Stream<int> watchCount({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
  });
}
