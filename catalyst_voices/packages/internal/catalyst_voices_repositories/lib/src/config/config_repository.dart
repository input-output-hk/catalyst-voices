import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/config/app_config_factory.dart';
import 'package:catalyst_voices_repositories/src/config/remote_config_source.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Allows to get app configuration from the server.
/// Contains a method which returns [AppConfig].
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
    var remoteConfig = await remoteSource.get().onError(
      (error, stackTrace) => const RemoteConfig(),
    );

    // Validate Sentry DSN and clear sentry config if invalid
    final dsn = remoteConfig.sentry?.dsn;
    if (dsn?.tryParseDsn() == null) {
      remoteConfig = remoteConfig.copyWith(
        sentry: const Optional(null),
      );
    }

    return AppConfigFactory.build(remoteConfig, env: env);
  }
}

extension on String? {
  Dsn? tryParseDsn() {
    try {
      return Dsn.parse(this ?? '');
    } catch (e) {
      return null;
    }
  }
}
