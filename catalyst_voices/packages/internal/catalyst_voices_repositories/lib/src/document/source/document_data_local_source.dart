import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class DocumentDataLocalSource implements DocumentDataSource {
  Future<bool> exists({required DocumentRef ref});

  Future<void> save({required DocumentData data});
}

final class CatalystDbDocumentDataSource implements DocumentDataLocalSource {
  final CatalystDatabase _database;

  CatalystDbDocumentDataSource(
    this._database,
  );

  @override
  Future<bool> exists({required DocumentRef ref}) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  Future<DocumentData> get({required DocumentRef ref}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> save({required DocumentData data}) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
