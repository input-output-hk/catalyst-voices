import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dev_tools_config_dto.g.dart';

@JsonSerializable()
class DevToolsConfigDto {
  final bool isDeveloper;

  DevToolsConfigDto({
    this.isDeveloper = false,
  });

  factory DevToolsConfigDto.fromJson(Map<String, dynamic> json) {
    return _$DevToolsConfigDtoFromJson(json);
  }

  DevToolsConfigDto.fromModel(DevToolsConfig data)
      : this(
          isDeveloper: data.isDeveloper,
        );

  Map<String, dynamic> toJson() => _$DevToolsConfigDtoToJson(this);

  DevToolsConfig toModel() {
    return DevToolsConfig(
      isDeveloper: isDeveloper,
    );
  }
}
