import 'package:drift/drift.dart';

final class DriftMigrationStrategy extends MigrationStrategy {
  DriftMigrationStrategy({
    required GeneratedDatabase database,
    required MigrationStrategy destructiveFallback,
  }) : super(
          onCreate: (m) async {
            await m.createAll();
          },
          onUpgrade: (m, from, to) async {
            await database.customStatement('PRAGMA foreign_keys = OFF');

            /// Provide non destructive migration when schema changes
            await destructiveFallback.onUpgrade(m, from, to);

            await database.customStatement('PRAGMA foreign_keys = ON;');
          },
          beforeOpen: (details) async {
            await database.customStatement('PRAGMA foreign_keys = ON');
          },
        );
}
