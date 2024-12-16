import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config_dto.g.dart';

@JsonSerializable()
final class AppConfigDto {
  @JsonKey(includeToJson: false, includeFromJson: false)
  final SentryConfigDto? sentry;
  final CacheConfigDto cache;

  const AppConfigDto({
    this.sentry,
    this.cache = const CacheConfigDto(),
  });

  AppConfigDto.fromModel(AppConfig data)
      : this(
          sentry: SentryConfigDto.fromModel(data.sentry),
          cache: CacheConfigDto.fromModel(data.cache),
        );

  factory AppConfigDto.fromJson(Map<String, dynamic> json) {
    return _$AppConfigDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppConfigDtoToJson(this);

  AppConfig toModel() {
    return AppConfig(
      sentry: sentry?.toModel() ?? const SentryConfig(),
      cache: cache.toModel(),
    );
  }
}

@JsonSerializable()
final class SentryConfigDto {
  final String dns;
  final String environment;
  final String release;

  const SentryConfigDto({
    required this.dns,
    required this.environment,
    required this.release,
  });

  SentryConfigDto.fromModel(SentryConfig data)
      : this(
          dns: data.dns,
          environment: data.environment,
          release: data.release,
        );

  factory SentryConfigDto.fromJson(Map<String, dynamic> json) {
    return _$SentryConfigDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SentryConfigDtoToJson(this);

  SentryConfig toModel() {
    return SentryConfig(
      dns: dns,
      environment: environment,
      release: release,
    );
  }
}

@JsonSerializable()
final class CacheConfigDto {
  final ExpiryDurationDto expiryDuration;

  const CacheConfigDto({
    this.expiryDuration = const ExpiryDurationDto(),
  });

  CacheConfigDto.fromModel(CacheConfig data)
      : this(
          expiryDuration: ExpiryDurationDto.fromModel(data.expiryDuration),
        );

  factory CacheConfigDto.fromJson(Map<String, dynamic> json) {
    return _$CacheConfigDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CacheConfigDtoToJson(this);

  CacheConfig toModel() {
    return CacheConfig(
      expiryDuration: expiryDuration.toModel(),
    );
  }
}

@JsonSerializable()
final class ExpiryDurationDto {
  @DurationConverter()
  final Duration keychainUnlock;

  const ExpiryDurationDto({
    this.keychainUnlock = const Duration(hours: 1),
  });

  ExpiryDurationDto.fromModel(ExpiryDuration data)
      : this(keychainUnlock: data.keychainUnlock);

  factory ExpiryDurationDto.fromJson(Map<String, dynamic> json) {
    return _$ExpiryDurationDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpiryDurationDtoToJson(this);

  ExpiryDuration toModel() {
    return ExpiryDuration(
      keychainUnlock: keychainUnlock,
    );
  }
}
