import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/favorites_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_favourite.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_favourite.drift.dart';
import 'package:drift/drift.dart';

@DriftAccessor(
  tables: [
    DocumentsFavorites,
  ],
)
class DriftFavoritesDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftFavoritesDaoMixin
    implements FavoritesDao {
  DriftFavoritesDao(super.attachedDatabase);

  @override
  Future<void> deleteWhere({required String id}) async {
    final idHiLo = UuidHiLo.from(id);

    final query = delete(documentsFavorites)
      ..where((tbl) {
        return tbl.idHi.equals(idHiLo.high) & tbl.idLo.equals(idHiLo.low);
      });

    await query.go();
  }

  @override
  Future<void> save(DocumentFavoriteEntity entity) async {
    await into(documentsFavorites).insert(
      entity,
      mode: InsertMode.insertOrIgnore,
    );
  }

  @override
  Stream<bool> watch({required String id}) {
    final idHiLo = UuidHiLo.from(id);
    final select = selectOnly(documentsFavorites)
      ..where(
        Expression.and([
          documentsFavorites.idHi.equals(idHiLo.high),
          documentsFavorites.idLo.equals(idHiLo.low),
        ]),
      )
      ..addColumns([
        documentsFavorites.isFavorite,
      ]);

    return select
        .map((row) => row.read(documentsFavorites.isFavorite))
        .watchSingleOrNull()
        .map((isFavorite) => isFavorite ?? false);
  }

  @override
  Stream<List<String>> watchAll({DocumentType? type}) {
    final select = selectOnly(documentsFavorites)
      ..addColumns([
        documentsFavorites.idHi,
        documentsFavorites.idLo,
      ]);

    if (type != null) {
      select.where(documentsFavorites.type.equalsValue(type));
    }

    return select.map((row) {
      final udHiLo = UuidHiLo(
        high: row.read(documentsFavorites.idHi)!,
        low: row.read(documentsFavorites.idLo)!,
      );
      return udHiLo.uuid;
    }).watch();
  }
}

abstract interface class FavoritesDao {
  Future<void> deleteWhere({required String id});

  Future<void> save(DocumentFavoriteEntity entity);

  Stream<bool> watch({required String id});

  Stream<List<String>> watchAll({DocumentType? type});
}
