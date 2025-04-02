import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/config/app_config_factory.dart';
import 'package:catalyst_voices_repositories/src/config/remote_config_source.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';

// ignore: one_member_abstracts
abstract interface class ConfigRepository {
  const factory ConfigRepository(
    RemoteConfigSource remoteSource,
  ) = ConfigRepositoryImpl;

  Future<AppConfigs> getAppConfig();
}

final class ConfigRepositoryImpl implements ConfigRepository {
  final RemoteConfigSource remoteSource;

  const ConfigRepositoryImpl(
    this.remoteSource,
  );

  @override
  Future<AppConfigs> getAppConfig() async {
    final remoteConfig = await remoteSource
        .get()
        .onError((error, stackTrace) => const RemoteConfig());

    final remoteEnvConfigs = remoteConfig.environments.map((key, value) {
      final env = AppEnvironmentType.values.asNameMap()[key];
      final config = RemoteEnvConfig.fromJson(value);

      return MapEntry(env, config);
    });

    return AppConfigs(
      version: remoteConfig.version ?? '0.0.1',
      createdAt: remoteConfig.createdAt ?? DateTime.now(),
      environments: AppEnvironmentType.values.map((env) {
        final remote = remoteEnvConfigs[env] ?? const RemoteEnvConfig();
        final envConfig = AppConfigFactory.build(env: env, remote: remote);

        return MapEntry(env, envConfig);
      }).toMap(),
    );
  }
}

extension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}
