import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/system_status/strategy/version_source_strategy.dart';

abstract interface class SystemStatusService {
  factory SystemStatusService(
    SystemStatusRepository systemStatusRepository,
    AppMetaStorage appMetaStorage, {
    VersionSourceStrategy? versionSourceStrategy,
  }) = SystemStatusServiceImpl;

  Future<List<ComponentStatus>> getComponentStatuses();

  Future<bool> isUpdateAvailable();

  Stream<List<ComponentStatus>> pollComponentStatuses({Duration interval});
}

class SystemStatusServiceImpl implements SystemStatusService {
  final AppMetaStorage _appMetaStorage;
  final VersionSourceStrategy _versionSourceStrategy;
  final SystemStatusRepository _statusRepository;

  SystemStatusServiceImpl(
    this._statusRepository,
    this._appMetaStorage, {
    VersionSourceStrategy? versionSourceStrategy,
  }) : _versionSourceStrategy =
           versionSourceStrategy ??
           VersionSourceStrategyFactory.getDefaultStrategyType(
             repository: _statusRepository,
           );

  @override
  Future<List<ComponentStatus>> getComponentStatuses() {
    return _statusRepository.getComponentStatuses();
  }

  @override
  Future<bool> isUpdateAvailable() async {
    final savedAppMetaData = await _appMetaStorage.read();
    final currentVersion = savedAppMetaData.appVersion;

    final availableVersion = await _versionSourceStrategy.getAvailableVersion();

    final isUpdateAvailable =
        currentVersion != null && availableVersion.isNewerThan(currentVersion);

    await _appMetaStorage.write(
      savedAppMetaData.copyWith(appVersion: Optional(availableVersion)),
    );

    return isUpdateAvailable;
  }

  @override
  Stream<List<ComponentStatus>> pollComponentStatuses({
    Duration interval = const Duration(seconds: 120),
  }) {
    return _statusRepository.pollComponentStatuses(interval: interval);
  }
}
