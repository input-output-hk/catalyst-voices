import 'package:catalyst_voices_models/catalyst_voices_models.dart';

// ignore: one_member_abstracts
abstract interface class ConfigRepository {
  factory ConfigRepository() {
    return ConfigRepositoryImpl();
  }

  Future<AppConfig> getAppConfig();
}

final class ConfigRepositoryImpl implements ConfigRepository {
  ConfigRepositoryImpl();

  @override
  Future<AppConfig> getAppConfig() {
    // TODO(damian-molinski): should be api call here.
    return Future.delayed(
      const Duration(milliseconds: 200),
      AppConfig.new,
    );
  }
}
