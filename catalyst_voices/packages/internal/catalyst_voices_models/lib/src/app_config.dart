import 'package:equatable/equatable.dart';

final class ApiConfig extends Equatable {
  final String gatewayUrl;
  final String vitUrl;
  final String reviewsUrl;

  const ApiConfig({
    this.gatewayUrl = 'https://gateway.dev.projectcatalyst.io/',
    this.vitUrl = 'https://core.dev.projectcatalyst.io/',
    this.reviewsUrl = 'https://api.reviews.dev.projectcatalyst.io/',
  });

  @override
  List<Object?> get props => [
        gatewayUrl,
        vitUrl,
        reviewsUrl,
      ];
}

final class AppConfig extends Equatable {
  final ApiConfig api;
  final CacheConfig cache;
  final DatabaseConfig database;
  final SentryConfig sentry;

  const AppConfig({
    this.api = const ApiConfig(),
    this.cache = const CacheConfig(),
    this.database = const DatabaseConfig(),
    this.sentry = const SentryConfig(),
  });

  @override
  List<Object?> get props => [
        api,
        cache,
        database,
        sentry,
      ];
}

final class CacheConfig extends Equatable {
  final ExpiryDuration expiryDuration;

  const CacheConfig({
    this.expiryDuration = const ExpiryDuration(),
  });

  @override
  List<Object?> get props => [expiryDuration];
}

final class DatabaseConfig extends Equatable {
  final String name;
  final String webSqlite3Wasm;
  final String webDriftWorker;

  const DatabaseConfig({
    this.name = 'catalyst_db',
    this.webSqlite3Wasm = 'sqlite3.wasm',
    this.webDriftWorker = 'drift_worker.js',
  });

  @override
  List<Object?> get props => [
        name,
        webSqlite3Wasm,
        webDriftWorker,
      ];
}

final class ExpiryDuration extends Equatable {
  final Duration keychainUnlock;

  const ExpiryDuration({
    this.keychainUnlock = const Duration(hours: 1),
  });

  @override
  List<Object?> get props => [keychainUnlock];
}

final class SentryConfig extends Equatable {
  final String dns;
  final String environment;
  final String release;

  const SentryConfig({
    // TODO(damian-molinski): default values should be changed.
    this.dns = 'https://example.com',
    this.environment = 'dev',
    this.release = '1.0.0',
  });

  @override
  List<Object?> get props => [
        dns,
        environment,
        release,
      ];
}
