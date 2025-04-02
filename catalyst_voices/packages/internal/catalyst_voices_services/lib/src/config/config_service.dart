import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

// ignore: one_member_abstracts
abstract interface class ConfigService {
  const factory ConfigService(ConfigRepository repository) = ConfigServiceImpl;

  Future<AppConfig> getAppConfig({
    required AppEnvironmentType env,
  });
}

final class ConfigServiceImpl implements ConfigService {
  final ConfigRepository _repository;

  const ConfigServiceImpl(
    this._repository,
  );

  @override
  Future<AppConfig> getAppConfig({
    required AppEnvironmentType env,
  }) async {
    final appConfigs = await _repository.getAppConfig();

    final envConfig = appConfigs.environments[env];

    return envConfig ?? const AppConfig.fallback();
  }
}
