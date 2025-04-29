import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_factories.dart';
import 'connection/test_connection.dart';
import 'drift_test_platforms.dart';

void main() {
  late DriftCatalystDatabase database;

  setUp(() async {
    final connection = await buildTestConnection();
    database = DriftCatalystDatabase(connection);
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
        final draftsCountBefore = await database.draftsDao.count();
        final documentsCountBefore = await database.documentsDao.count();

        expect(draftsCountBefore, drafts.length);
        expect(documentsCountBefore, documents.length);

        await database.clear();

        final draftsCountAfter = await database.draftsDao.count();
        final documentsCountAfter = await database.documentsDao.count();

        expect(draftsCountAfter, isZero);
        expect(documentsCountAfter, isZero);
      },
      onPlatform: driftOnPlatforms,
    );
  });
}
