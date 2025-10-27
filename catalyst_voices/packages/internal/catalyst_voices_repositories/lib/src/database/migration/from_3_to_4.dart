//ignore_for_file: avoid_dynamic_calls

import 'package:catalyst_voices_repositories/src/database/catalyst_database.steps.dart';
import 'package:drift/drift.dart';
import 'package:sqlite3/common.dart' as sqlite3 show jsonb;

Future<void> from3To4(Migrator m, Schema4 schema) async {
  /*await m.createTable(schema.documentsV2);
  await m.createTable(schema.documentsFavoritesV2);
  await m.createTable(schema.localDocumentsDrafts);*/

  await m.createTable(schema.documentsV2);

  try {
    final oldDocs = await m.database.customSelect('SELECT * FROM documents LIMIT 10').get();

    for (final oldDoc in oldDocs) {
      final rawMetadata = oldDoc.read<Uint8List>('metadata');
      final metadata = sqlite3.jsonb.decode(rawMetadata)! as Map<String, dynamic>;

      final id = metadata['selfRef']['id'] as String;
      final ver = metadata['selfRef']['version'] as String;
      final type = metadata['type'] as String;
      final refId = metadata['ref']?['id'] as String?;
      final refVer = metadata['ref']?['version'] as String?;
      final replyId = metadata['reply']?['id'] as String?;
      final replyVer = metadata['reply']?['version'] as String?;
      final categoryId = metadata['categoryId']?['id'] as String?;
      final categoryVer = metadata['categoryId']?['version'] as String?;
      final authors = metadata['authors'] as List<dynamic>?;
      final parameters = metadata['parameters'] as List<dynamic>?;

      print(
        'id[$id], ver[$ver], '
        'type[$type], '
        'refId[$refId], refVer[$refVer], '
        'replyId[$replyId], replyVer[$replyVer], '
        'categoryId[$categoryId], categoryVer[$categoryVer], '
        'authors: $authors, '
        'parameters: $parameters',
      );
    }
  } catch (error) {
    print('error -> $error');
  }
  throw StateError('Noop');
}

// TODO(damian-molinski): define DocumentDataMetadataDtoDbV3 use for mapping
// TODO(damian-molinski): paginated data migration
