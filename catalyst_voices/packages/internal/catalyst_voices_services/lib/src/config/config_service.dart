import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

// ignore: one_member_abstracts
abstract interface class ConfigService {
  factory ConfigService(ConfigRepository repository) {
    return ConfigServiceImpl(repository);
  }

  Future<AppConfig> getAppConfig();
}

final class ConfigServiceImpl implements ConfigService {
  final ConfigRepository _repository;

  ConfigServiceImpl(
    this._repository,
  );

  @override
  Future<AppConfig> getAppConfig() => _repository.getAppConfig();
}
