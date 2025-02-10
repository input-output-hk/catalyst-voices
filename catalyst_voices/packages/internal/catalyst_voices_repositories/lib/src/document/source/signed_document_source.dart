import 'package:catalyst_voices_models/catalyst_voices_models.dart';

export 'signed_document_local_source.dart' show SignedDocumentLocalSource;
export 'signed_document_remote_source.dart' show SignedDocumentRemoteSource;

//ignore: one_member_abstracts
abstract interface class SignedDocumentSource {
  Future<SignedDocumentData> get({required SignedDocumentRef ref});
}
