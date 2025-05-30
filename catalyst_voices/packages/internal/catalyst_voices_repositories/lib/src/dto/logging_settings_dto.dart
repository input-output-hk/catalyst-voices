import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logging_settings_dto.g.dart';

@JsonSerializable()
final class LevelDto {
  final String name;
  final int value;

  LevelDto({
    required this.name,
    required this.value,
  });

  factory LevelDto.fromJson(Map<String, dynamic> json) {
    return _$LevelDtoFromJson(json);
  }

  LevelDto.fromModel(Level data)
      : this(
          name: data.name,
          value: data.value,
        );

  Map<String, dynamic> toJson() => _$LevelDtoToJson(this);

  Level toModel() => Level(name, value);
}

@JsonSerializable()
final class LoggingSettingsDto {
  final bool? printToConsole;
  final LevelDto? level;
  final bool? collectLogs;

  LoggingSettingsDto({
    this.printToConsole,
    this.level,
    this.collectLogs,
  });

  factory LoggingSettingsDto.fromJson(Map<String, dynamic> json) {
    return _$LoggingSettingsDtoFromJson(json);
  }

  LoggingSettingsDto.fromModel(LoggingSettings data)
      : this(
          printToConsole: data.printToConsole,
          level: data.level != null ? LevelDto.fromModel(data.level!) : null,
          collectLogs: data.collectLogs,
        );

  Map<String, dynamic> toJson() => _$LoggingSettingsDtoToJson(this);

  LoggingSettings toModel() {
    return LoggingSettings(
      printToConsole: printToConsole,
      level: level?.toModel(),
      collectLogs: collectLogs,
    );
  }
}
