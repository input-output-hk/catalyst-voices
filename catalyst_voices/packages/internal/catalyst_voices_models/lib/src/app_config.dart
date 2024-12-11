import 'package:catalyst_voices_models/src/json_converters.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';

@JsonSerializable()
final class AppConfig extends Equatable {
  // Not ready. See comment below.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final SentryConfig sentry;
  final CacheConfig cache;

  const AppConfig({
    this.sentry = const SentryConfig(),
    this.cache = const CacheConfig(),
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return _$AppConfigFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  @override
  List<Object?> get props => [sentry, cache];
}

@JsonSerializable()
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

  factory SentryConfig.fromJson(Map<String, dynamic> json) {
    return _$SentryConfigFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SentryConfigToJson(this);

  @override
  List<Object?> get props => [
        dns,
        environment,
        release,
      ];
}

@JsonSerializable()
final class CacheConfig extends Equatable {
  final ExpiryDuration expiryDuration;

  const CacheConfig({
    this.expiryDuration = const ExpiryDuration(),
  });

  factory CacheConfig.fromJson(Map<String, dynamic> json) {
    return _$CacheConfigFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CacheConfigToJson(this);

  @override
  List<Object?> get props => [expiryDuration];
}

@JsonSerializable()
final class ExpiryDuration extends Equatable {
  @DurationConverter()
  final Duration keychainUnlock;

  const ExpiryDuration({
    this.keychainUnlock = const Duration(hours: 1),
  });

  factory ExpiryDuration.fromJson(Map<String, dynamic> json) {
    return _$ExpiryDurationFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpiryDurationToJson(this);

  @override
  List<Object?> get props => [keychainUnlock];
}
