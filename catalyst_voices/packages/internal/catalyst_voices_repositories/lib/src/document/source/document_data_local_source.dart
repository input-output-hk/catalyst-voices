import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class DocumentDataLocalSource implements DocumentDataSource {
  Future<bool> exists({required DocumentRef ref});

  Future<List<DocumentData>> queryVersionsOfId({required String id});

  Future<void> save({required DocumentData data});

  Stream<DocumentData?> watch({required DocumentRef ref});

  Future<DocumentData?> getLatest({
    CatalystId? authorId,
  });
}

/// See [DatabaseDraftsDataSource].
abstract interface class DraftDataSource implements DocumentDataLocalSource {
  Future<void> delete({
    required DraftRef ref,
  });

  @override
  Future<List<TypedDocumentRef>> index();

  Future<void> update({
    required DraftRef ref,
    required DocumentDataContent content,
  });

  Stream<List<DocumentData>> watchAll({
    int? limit,
    DocumentType? type,
    CatalystId? authorId,
  });
}

/// See [DatabaseDocumentsDataSource].
abstract interface class SignedDocumentDataSource
    implements DocumentDataLocalSource {
  Future<int> getRefCount({
    required DocumentRef ref,
    required DocumentType type,
  });

  Future<DocumentData?> getRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
  });

  Stream<List<DocumentData>> watchAll({
    int? limit,
    required bool unique,
    DocumentType? type,
    CatalystId? authorId,
    DocumentRef? refTo,
  });

  Stream<int> watchCount({
    DocumentRef? refTo,
    DocumentType? type,
  });

  Stream<DocumentData?> watchRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
  });
}
