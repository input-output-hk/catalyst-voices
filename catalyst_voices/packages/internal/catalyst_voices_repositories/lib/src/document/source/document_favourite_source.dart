import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

final class DatabaseDocumentFavouriteSource implements DocumentFavouriteSource {
  final CatalystDatabase _database;

  DatabaseDocumentFavouriteSource(
    this._database,
  );
}

abstract interface class DocumentFavouriteSource {
  Future<void> deleteDocumentFavourite(String id);

  Future<void> updateDocumentFavourite(
    String id, {
    required bool isFavourite,
  });

  Stream<List<DocumentRef>> watchAllFavouriteRefs({
    DocumentType? type,
  });

  Stream<bool> watchIsDocumentFavourite(String id);
}
