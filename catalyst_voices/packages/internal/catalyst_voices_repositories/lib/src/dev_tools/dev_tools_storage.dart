import 'dart:convert';

import 'package:catalyst_voices_repositories/src/dto/dev_tools/dev_tools_config_dto.dart';
import 'package:catalyst_voices_repositories/src/storage/local_storage.dart';

const _configKey = 'Config';
const _key = 'DevTools';

abstract interface class DevToolsStorage {
  Future<DevToolsConfigDto?> read();

  Future<void> write(DevToolsConfigDto? value);
}

final class DevToolsStorageLocal extends LocalStorage implements DevToolsStorage {
  DevToolsStorageLocal({
    required super.sharedPreferences,
  }) : super(
         key: _key,
         allowList: {
           _configKey,
         },
       );

  @override
  Future<DevToolsConfigDto?> read() async {
    final encoded = await readString(key: _configKey);
    if (encoded == null) {
      return null;
    }

    final json = jsonDecode(encoded) as Map<String, dynamic>;
    return DevToolsConfigDto.fromJson(json);
  }

  @override
  Future<void> write(DevToolsConfigDto? value) async {
    if (value == null) {
      delete(key: _configKey);
      return;
    }

    final json = value.toJson();
    final encoded = jsonEncode(json);
    await writeString(encoded, key: _configKey);
  }
}
