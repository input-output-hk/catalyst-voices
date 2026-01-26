import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/document_composite_factory.dart';
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
        final documents = List.generate(5, (index) => DocumentCompositeFactory.create());

        // When
        await database.documentsV2Dao.saveAll(documents);

        // Then
        final documentsCountBefore = await database.documentsV2Dao.count();

        expect(documentsCountBefore, documents.length);

        await database.clear();

        final documentsCountAfter = await database.documentsV2Dao.count();

        expect(documentsCountAfter, isZero);
      },
      onPlatform: driftOnPlatforms,
    );
  });
}
