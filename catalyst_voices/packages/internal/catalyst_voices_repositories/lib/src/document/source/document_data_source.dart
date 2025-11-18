import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class DocumentDataSource {
  Future<DocumentData?> get({DocumentRef? ref});

  Future<DocumentRef?> getLatestOf({required DocumentRef ref});
}
