import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class DevToolsService {
  const factory DevToolsService(
    DevToolsRepository devToolsRepository,
    AppEnvironment environment,
    AppConfig config,
  ) = DevToolsServiceImpl;

  Future<SystemInfo> getSystemInfo();

  Future<bool> isDeveloper();

  Future<void> updateDevTools({required bool isEnabled});
}

final class DevToolsServiceImpl implements DevToolsService {
  final DevToolsRepository _devToolsRepository;
  final AppEnvironment _environment;
  final AppConfig _config;

  const DevToolsServiceImpl(
    this._devToolsRepository,
    this._environment,
    this._config,
  );

  @override
  Future<SystemInfo> getSystemInfo() async {
    final appInfo = await _devToolsRepository.readAppInfo();
    final gatewayInfo = await _devToolsRepository.readGatewayInfo();
    final environment = _environment;
    final config = _config;

    return SystemInfo(
      app: appInfo,
      gateway: gatewayInfo,
      config: config,
      environment: environment,
    );
  }

  @override
  Future<bool> isDeveloper() => _devToolsRepository.readConfig().then((value) => value.isDeveloper);

  @override
  Future<void> updateDevTools({
    required bool isEnabled,
  }) async {
    final config = await _devToolsRepository.readConfig();
    final updatedConfig = config.copyWith(isDeveloper: isEnabled);
    await _devToolsRepository.writeConfig(updatedConfig);
  }
}
