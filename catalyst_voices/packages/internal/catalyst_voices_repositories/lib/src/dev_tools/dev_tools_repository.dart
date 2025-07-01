import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dev_tools/dev_tools_storage.dart';
import 'package:catalyst_voices_repositories/src/dto/dev_tools/dev_tools_config_dto.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Repository for reading and writing data for DevTools.
abstract interface class DevToolsRepository {
  const factory DevToolsRepository(
    DevToolsStorage storage,
  ) = DevToolsRepositoryImpl;

  Future<AppInfo> readAppInfo();

  Future<DevToolsConfig> readConfig();

  Future<GatewayInfo> readGatewayInfo();

  Future<void> writeConfig(DevToolsConfig value);
}

final class DevToolsRepositoryImpl implements DevToolsRepository {
  final DevToolsStorage _storage;

  const DevToolsRepositoryImpl(
    this._storage,
  );

  @override
  Future<AppInfo> readAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return AppInfo(
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }

  @override
  Future<DevToolsConfig> readConfig() async {
    final dto = await _storage.read();
    return dto?.toModel() ?? const DevToolsConfig();
  }

  @override
  Future<GatewayInfo> readGatewayInfo() async {
    // TODO(damian-molinski): ask any endpoint and read response headers
    return const GatewayInfo();
  }

  @override
  Future<void> writeConfig(DevToolsConfig value) async {
    final dto = DevToolsConfigDto.fromModel(value);
    await _storage.write(dto);
  }
}
