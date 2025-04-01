import 'package:json_annotation/json_annotation.dart';

part 'remote_cache_config.g.dart';

@JsonSerializable(createToJson: false)
final class RemoteCacheConfig {
  final RemoteExpiryDuration? expiryDuration;

  const RemoteCacheConfig({
    this.expiryDuration,
  });

  factory RemoteCacheConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteCacheConfigFromJson(json);
  }
}

@JsonSerializable(createToJson: false)
final class RemoteExpiryDuration {
  final Duration? keychainUnlock;

  const RemoteExpiryDuration({
    this.keychainUnlock,
  });

  factory RemoteExpiryDuration.fromJson(Map<String, dynamic> json) {
    return _$RemoteExpiryDurationFromJson(json);
  }
}
