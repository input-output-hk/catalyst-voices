import 'package:equatable/equatable.dart';

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

  const CatalystDriftDatabaseConfig({
    required super.name,
    required this.web,
  });

  @override
  List<Object?> get props => [...super.props, web];
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
