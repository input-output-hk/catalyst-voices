import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class SignedDocumentLocalSource
    implements SignedDocumentSource {
  factory SignedDocumentLocalSource(CatalystDatabase database) =
      CatalystDbSignedDocumentSource;

  Future<bool> exists({required SignedDocumentRef ref});

  Future<void> save({required SignedDocumentData data});
}

final class CatalystDbSignedDocumentSource
    implements SignedDocumentLocalSource {
  final CatalystDatabase _database;

  CatalystDbSignedDocumentSource(
    this._database,
  );

  @override
  Future<bool> exists({required SignedDocumentRef ref}) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  Future<SignedDocumentData> get({required SignedDocumentRef ref}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> save({required SignedDocumentData data}) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
