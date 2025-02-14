import 'package:equatable/equatable.dart';

final class AppConfig extends Equatable {
  final ApiConfig api;
  final SentryConfig sentry;
  final CacheConfig cache;

  const AppConfig({
    this.api = const ApiConfig(),
    this.sentry = const SentryConfig(),
    this.cache = const CacheConfig(),
  });

  @override
  List<Object?> get props => [api, sentry, cache];
}

final class ApiConfig extends Equatable {
  final String catGatewayUrl;
  final String vitUrl;
  final String reviewModuleUrl;

  // TODO(damian-molinski): review module url have to be updated
  const ApiConfig({
    this.catGatewayUrl = 'https://gateway.dev.projectcatalyst.io/api/',
    this.vitUrl = 'https://core.dev.projectcatalyst.io/api/',
    this.reviewModuleUrl = 'https://',
  });

  @override
  List<Object?> get props => [
        catGatewayUrl,
        vitUrl,
        reviewModuleUrl,
      ];
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

final class CacheConfig extends Equatable {
  final ExpiryDuration expiryDuration;

  const CacheConfig({
    this.expiryDuration = const ExpiryDuration(),
  });

  @override
  List<Object?> get props => [expiryDuration];
}

final class ExpiryDuration extends Equatable {
  final Duration keychainUnlock;

  const ExpiryDuration({
    this.keychainUnlock = const Duration(hours: 1),
  });

  @override
  List<Object?> get props => [keychainUnlock];
}
