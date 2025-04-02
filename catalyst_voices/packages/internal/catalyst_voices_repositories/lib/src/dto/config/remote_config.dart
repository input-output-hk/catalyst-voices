import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_config.g.dart';

@JsonSerializable()
final class RemoteConfig {
  final String? version;
  final DateTime? createdAt;
  final Map<String, Map<String, dynamic>> environments;

  const RemoteConfig({
    this.version,
    this.createdAt,
    this.environments = const {},
  });

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteConfigFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RemoteConfigToJson(this);
}

@JsonSerializable(createToJson: false)
final class RemoteEnvConfig {
  final RemoteApiConfig? api;
  final RemoteCacheConfig? cache;
  final RemoteSentryConfig? sentry;
  final RemoteBlockchainConfig? blockchain;

  const RemoteEnvConfig({
    this.api,
    this.cache,
    this.sentry,
    this.blockchain,
  });

  factory RemoteEnvConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteEnvConfigFromJson(json);
  }
}
