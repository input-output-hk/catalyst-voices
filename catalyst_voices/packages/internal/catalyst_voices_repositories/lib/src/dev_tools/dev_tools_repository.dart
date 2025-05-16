import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dev_tools/dev_tools_storage.dart';
import 'package:catalyst_voices_repositories/src/dto/dev_tools/dev_tools_config_dto.dart';

abstract interface class DevToolsRepository {
  const factory DevToolsRepository(
    DevToolsStorage storage,
  ) = DevToolsRepositoryImpl;

  Future<DevToolsConfig> readConfig();

  Future<void> writeConfig(DevToolsConfig value);
}

final class DevToolsRepositoryImpl implements DevToolsRepository {
  final DevToolsStorage _storage;

  const DevToolsRepositoryImpl(
    this._storage,
  );

  @override
  Future<DevToolsConfig> readConfig() async {
    final dto = await _storage.read();
    return dto?.toModel() ?? const DevToolsConfig();
  }

  @override
  Future<void> writeConfig(DevToolsConfig value) async {
    final dto = DevToolsConfigDto.fromModel(value);
    await _storage.write(dto);
  }
}
