import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/config/remote_config_source.dart';

// ignore: one_member_abstracts
abstract interface class ConfigRepository {
  const factory ConfigRepository(
    RemoteConfigSource remoteSource,
  ) = ConfigRepositoryImpl;

  Future<AppConfig> getAppConfig();
}

final class ConfigRepositoryImpl implements ConfigRepository {
  final RemoteConfigSource remoteSource;

  const ConfigRepositoryImpl(
    this.remoteSource,
  );

  @override
  Future<AppConfig> getAppConfig() async {
    // TODO(damian-molinski): should be api call here.
    return Future.delayed(
      const Duration(milliseconds: 200),
      AppConfig.new,
    );
  }
}
