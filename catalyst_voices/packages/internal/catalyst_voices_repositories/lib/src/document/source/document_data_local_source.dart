import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class DocumentDataLocalSource implements DocumentDataSource {
  Future<bool> exists({required DocumentRef ref});

  Future<void> save({required DocumentData data});

  Stream<DocumentData?> watch({required DocumentRef ref});
}

/// See [DatabaseDraftsDataSource].
abstract interface class DraftDataSource implements DocumentDataLocalSource {
  Future<void> update({
    required DraftRef ref,
    required DocumentDataContent content,
  });
}

/// See [DatabaseDocumentsDataSource].
abstract interface class SignedDocumentDataSource
    implements DocumentDataLocalSource {
  Stream<List<DocumentData>> watchLatestVersions({int? limit});
}
