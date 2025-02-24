import 'package:catalyst_voices_models/catalyst_voices_models.dart';

//ignore: one_member_abstracts
abstract interface class DocumentDataSource {
  Future<DocumentData> get({required DocumentRef ref});
}
