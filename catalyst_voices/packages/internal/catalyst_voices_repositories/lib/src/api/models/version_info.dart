import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version_info.g.dart';

@JsonSerializable()
class VersionInfo {
  @JsonKey(name: 'version')
  final String versionNumber;

  @JsonKey(name: 'build_number')
  final String buildNumber;

  const VersionInfo({required this.versionNumber, required this.buildNumber});

  factory VersionInfo.fromJson(Map<String, dynamic> json) => _$VersionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VersionInfoToJson(this);

  AppVersion toModel() => AppVersion(
    versionNumber: versionNumber,
    buildNumber: int.parse(buildNumber),
  );
}
