import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class DocumentDataSource {
  Future<List<DocumentRef>> index();

  Future<DocumentData> get({required DocumentRef ref});
}
