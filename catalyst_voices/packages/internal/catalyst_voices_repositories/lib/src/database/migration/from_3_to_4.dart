import 'package:catalyst_voices_repositories/src/database/catalyst_database.steps.dart';
import 'package:drift/drift.dart';

Future<void> from3To4(Migrator m, Schema4 schema) async {
  await m.createTable(schema.documentsV2);
  await m.createTable(schema.documentsFavoritesV2);
  await m.createTable(schema.localDocumentsDrafts);
}
