import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_factories.dart';

void main() {
  late DriftCatalystDatabase database;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DriftCatalystDatabase(inMemory);
  });

  tearDown(() async {
    await database.close();
  });

  group(DriftCatalystDatabase, () {
    test(
      'clear removes all documents and drafts',
      () async {
        // Given
        final drafts = List.generate(5, (index) => DraftFactory.build());
        final documents = List.generate(
          5,
          (index) => DocumentWithMetadataFactory.build(),
        );

        // When
        await database.documentsDao.saveAll(documents);
        await database.draftsDao.saveAll(drafts);

        // Then
        final draftsCountBefore = await database.draftsDao.countAll();
        final documentsCountBefore = await database.documentsDao.countAll();

        expect(draftsCountBefore, drafts.length);
        expect(documentsCountBefore, documents.length);

        await database.clear();

        final draftsCountAfter = await database.draftsDao.countAll();
        final documentsCountAfter = await database.documentsDao.countAll();

        expect(draftsCountAfter, isZero);
        expect(documentsCountAfter, isZero);
      },
    );
  });
}
