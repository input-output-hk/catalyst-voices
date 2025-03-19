import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

final class DatabaseDocumentFavoriteSource implements DocumentFavoriteSource {
  final CatalystDatabase _database;

  DatabaseDocumentFavoriteSource(
    this._database,
  );

  @override
  Future<void> updateDocumentFavorite(
    String id, {
    required DocumentType type,
    required bool isFavorite,
  }) {
    if (!isFavorite) {
      return _database.favoritesDao.deleteWhere(id: id);
    }

    final idHiLo = UuidHiLo.from(id);
    final entity = DocumentFavoriteEntity(
      idHi: idHiLo.high,
      idLo: idHiLo.low,
      isFavorite: isFavorite,
      type: type,
    );

    return _database.favoritesDao.save(entity);
  }

  @override
  Stream<List<String>> watchAllFavoriteIds({DocumentType? type}) {
    return _database.favoritesDao.watchAll(type: type);
  }

  @override
  Stream<bool> watchIsDocumentFavorite(String id) {
    return _database.favoritesDao.watch(id: id);
  }
}

abstract interface class DocumentFavoriteSource {
  Future<void> updateDocumentFavorite(
    String id, {
    required DocumentType type,
    required bool isFavorite,
  });

  Stream<List<String>> watchAllFavoriteIds({
    DocumentType? type,
  });

  Stream<bool> watchIsDocumentFavorite(String id);
}
