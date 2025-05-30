import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/logging_settings_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _key = 'Logging';
const _settingsKey = 'Settings';

final class LoggingSettingsLocalStorage extends LocalStorage implements LoggingSettingsStorage {
  LoggingSettingsLocalStorage({
    required super.sharedPreferences,
  }) : super(
          key: _key,
          allowList: {
            _settingsKey,
          },
        );

  @override
  Future<LoggingSettings> read() async {
    final encoded = await readString(key: _settingsKey);
    final json = encoded != null ? jsonDecode(encoded) as Map<String, dynamic> : null;
    final dto = json != null ? LoggingSettingsDto.fromJson(json) : null;
    return dto?.toModel() ?? const LoggingSettings();
  }

  @override
  Future<void> write(LoggingSettings data) async {
    final dto = LoggingSettingsDto.fromModel(data);
    final json = dto.toJson();
    final encoded = jsonEncode(json);
    await writeString(encoded, key: _settingsKey);
  }
}

abstract interface class LoggingSettingsStorage {
  Future<LoggingSettings> read();

  Future<void> write(LoggingSettings data);
}
