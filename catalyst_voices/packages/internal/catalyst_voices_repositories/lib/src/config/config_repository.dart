import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/config/app_config_factory.dart';
import 'package:catalyst_voices_repositories/src/config/remote_config_source.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';

// ignore: one_member_abstracts
abstract interface class ConfigRepository {
  const factory ConfigRepository(
    RemoteConfigSource remoteSource,
  ) = ConfigRepositoryImpl;

  Future<AppConfig> getConfig({
    required AppEnvironmentType env,
  });
}

final class ConfigRepositoryImpl implements ConfigRepository {
  final RemoteConfigSource remoteSource;

  const ConfigRepositoryImpl(
    this.remoteSource,
  );

  @override
  Future<AppConfig> getConfig({
    required AppEnvironmentType env,
  }) async {
    final remoteConfig =
        await remoteSource.get().onError((error, stackTrace) => const RemoteConfig());

    return AppConfigFactory.build(remoteConfig, env: env);
  }
}
