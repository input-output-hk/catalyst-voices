import 'package:catalyst_voices_repositories/src/database/migration/from_3_to_4.dart';
import 'package:catalyst_voices_repositories/src/database/migration/schema_versions.g.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

/// Migration strategy for drift database.
final class DriftMigrationStrategy extends MigrationStrategy {
  DriftMigrationStrategy({
    required GeneratedDatabase database,
    required MigrationStrategy destructiveFallback,
  }) : super(
         onCreate: (m) => m.createAll(),
         onUpgrade: (m, from, to) async {
           final delegate = from < 3
               ? destructiveFallback.onUpgrade
               : stepByStep(from3To4: from3To4);

           await database.customStatement('PRAGMA foreign_keys = OFF');
           await delegate(m, from, to);

           if (kDebugMode) {
             final wrongForeignKeys = await database.customSelect('PRAGMA foreign_key_check').get();
             assert(wrongForeignKeys.isEmpty, '${wrongForeignKeys.map((e) => e.data)}');
           }
         },
         beforeOpen: (details) async {
           await database.customStatement('PRAGMA foreign_keys = ON');
         },
       );
}
