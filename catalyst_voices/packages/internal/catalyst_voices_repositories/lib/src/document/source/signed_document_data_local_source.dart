import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// See [DatabaseDocumentsDataSource].
abstract interface class SignedDocumentDataSource implements DocumentDataLocalSource {
  @override
  Future<DocumentData?> get({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    CatalystId? authorId,
  });

  @override
  Stream<List<DocumentData>> watchAll({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? refTo,
    CatalystId? authorId,
    bool latestOnly,
    int limit,
    int offset,
  });
}
