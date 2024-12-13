import 'package:equatable/equatable.dart';

part 'app_config.g.dart';

final class AppConfig extends Equatable {
  final SentryConfig sentry;
  final CacheConfig cache;

  const AppConfig({
    this.sentry = const SentryConfig(),
    this.cache = const CacheConfig(),
  });

  @override
  List<Object?> get props => [sentry, cache];
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
