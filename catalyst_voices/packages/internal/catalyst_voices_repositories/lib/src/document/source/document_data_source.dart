import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class DocumentDataSource {
  Future<DocumentData?> get(DocumentRef ref);

  Future<DocumentRef?> getLatestRefOf(DocumentRef ref);
}
