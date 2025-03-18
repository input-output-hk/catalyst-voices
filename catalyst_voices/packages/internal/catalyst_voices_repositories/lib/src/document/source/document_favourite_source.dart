import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_favourite.drift.dart';

final class DatabaseDocumentFavouriteSource implements DocumentFavouriteSource {
  final CatalystDatabase _database;

  DatabaseDocumentFavouriteSource(
    this._database,
  );

  @override
  Future<void> updateDocumentFavourite(
    String id, {
    required DocumentType type,
    required bool isFavourite,
  }) {
    final idHiLo = UuidHiLo.from(id);
    final entity = DocumentFavouriteEntity(
      idHi: idHiLo.high,
      idLo: idHiLo.low,
      isFavourite: isFavourite,
      type: type,
    );

    return _database.favouritesDao.upsert(entity);
  }

  @override
  Stream<List<String>> watchAllFavouriteIds({DocumentType? type}) {
    return _database.favouritesDao.watchAll(type: type);
  }

  @override
  Stream<bool> watchIsDocumentFavourite(String id) {
    return _database.favouritesDao.watch(id: id);
  }
}

abstract interface class DocumentFavouriteSource {
  Future<void> updateDocumentFavourite(
    String id, {
    required DocumentType type,
    required bool isFavourite,
  });

  Stream<List<String>> watchAllFavouriteIds({
    DocumentType? type,
  });

  Stream<bool> watchIsDocumentFavourite(String id);
}
