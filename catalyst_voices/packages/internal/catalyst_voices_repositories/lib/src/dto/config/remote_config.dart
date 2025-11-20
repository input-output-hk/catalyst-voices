import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_config.g.dart';

@JsonSerializable(createToJson: false)
final class RemoteConfig {
  final String? version;
  final DateTime? createdAt;
  final RemoteCacheConfig? cache;
  final RemoteSentryConfig? sentry;
  final RemoteBlockchainConfig? blockchain;

  const RemoteConfig({
    this.version,
    this.createdAt,
    this.cache,
    this.sentry,
    this.blockchain,
  });

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteConfigFromJson(json);
  }

  RemoteConfig copyWith({
    Optional<RemoteSentryConfig>? sentry,
  }) {
    return RemoteConfig(
      version: version,
      createdAt: createdAt,
      cache: cache,
      sentry: sentry.dataOr(this.sentry),
      blockchain: blockchain,
    );
  }
}
