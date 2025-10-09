import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract base class CatalystDatabaseConfig extends Equatable {
  final String name;

  const CatalystDatabaseConfig({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}

final class CatalystDriftDatabaseConfig extends CatalystDatabaseConfig {
  final CatalystDriftDatabaseWebConfig web;
  final CatalystDriftDatabaseNativeConfig native;

  const CatalystDriftDatabaseConfig({
    required super.name,
    required this.web,
    required this.native,
  });

  @override
  List<Object?> get props => [...super.props, web, native];
}

final class CatalystDriftDatabaseNativeConfig extends Equatable {
  /// Resolves where database file will be stored.
  final AsyncValueGetter<String> dbDir;

  /// Resolves where supporting, temporary, database files will be stored.
  /// For example big queries caching will be done here.
  final AsyncValueGetter<String> dbTempDir;

  const CatalystDriftDatabaseNativeConfig({
    required this.dbDir,
    required this.dbTempDir,
  });

  @override
  List<Object?> get props => [dbDir, dbTempDir];
}

/// See README to learn more about sqlite3Wasm / driftWorker.
final class CatalystDriftDatabaseWebConfig extends Equatable {
  final Uri sqlite3Wasm;
  final Uri driftWorker;

  const CatalystDriftDatabaseWebConfig({
    required this.sqlite3Wasm,
    required this.driftWorker,
  });

  @override
  List<Object?> get props => [sqlite3Wasm, driftWorker];
}
