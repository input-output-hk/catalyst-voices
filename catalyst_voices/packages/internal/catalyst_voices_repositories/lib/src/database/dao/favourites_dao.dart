import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/favourites_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_favourite.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_favourite.drift.dart';
import 'package:drift/drift.dart';

@DriftAccessor(
  tables: [
    DocumentsFavourite,
  ],
)
class DriftFavouritesDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftFavouritesDaoMixin
    implements FavouritesDao {
  DriftFavouritesDao(super.attachedDatabase);

  @override
  Future<void> upsert(DocumentFavouriteEntity entity) async {
    await into(documentsFavourite).insert(
      entity,
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Stream<bool> watch({required String id}) {
    final idHiLo = UuidHiLo.from(id);
    final select = selectOnly(documentsFavourite)
      ..where(
        Expression.and([
          documentsFavourite.idHi.equals(idHiLo.high),
          documentsFavourite.idLo.equals(idHiLo.low),
        ]),
      )
      ..addColumns([
        documentsFavourite.isFavourite,
      ]);

    return select
        .map((row) => row.read(documentsFavourite.isFavourite))
        .watchSingleOrNull()
        .map((isFavourite) => isFavourite ?? false);
  }

  @override
  Stream<List<String>> watchAll({DocumentType? type}) {
    final select = selectOnly(documentsFavourite)
      ..addColumns([
        documentsFavourite.idHi,
        documentsFavourite.idLo,
      ]);

    if (type != null) {
      select.where(documentsFavourite.type.equalsValue(type));
    }

    return select.map((row) {
      final udHiLo = UuidHiLo(
        high: row.read(documentsFavourite.idHi)!,
        low: row.read(documentsFavourite.idLo)!,
      );
      return udHiLo.uuid;
    }).watch();
  }
}

abstract interface class FavouritesDao {
  Future<void> upsert(DocumentFavouriteEntity entity);

  Stream<bool> watch({required String id});

  Stream<List<String>> watchAll({DocumentType? type});
}
