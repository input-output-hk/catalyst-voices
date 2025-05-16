import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class DevToolsService {
  const factory DevToolsService(
    DevToolsRepository devToolsRepository,
  ) = DevToolsServiceImpl;

  Future<bool> isDeveloper();

  Future<void> updateDevTools({required bool isEnabled});
}

final class DevToolsServiceImpl implements DevToolsService {
  final DevToolsRepository _devToolsRepository;

  const DevToolsServiceImpl(
    this._devToolsRepository,
  );

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
