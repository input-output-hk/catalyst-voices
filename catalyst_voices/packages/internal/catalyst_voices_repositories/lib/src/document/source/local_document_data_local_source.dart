import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// See [DatabaseDraftsDataSource].
abstract interface class DraftDataSource implements DocumentDataLocalSource {
  @override
  Future<int> delete({
    DocumentRef? ref,
    List<DocumentType>? typeNotIn,
  });

  Future<void> update({
    required DraftRef ref,
    required DocumentDataContent content,
  });
}
