import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter/foundation.dart';

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
    final config = await _repository.getConfig(env: env);
    final sentry = config.sentry.copyWith(
      debug: kDebugMode,
      attachScreenshot: env == AppEnvironmentType.dev,
    );

    return config.copyWith(sentry: sentry);
  }
}
