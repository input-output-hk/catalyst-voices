import 'package:catalyst_voices_repositories/src/api/models/stake_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'full_stake_info.g.dart';

/// Full user's cardano stake info.
///
/// Used as response for GET /api/v1/cardano/assets/{stake_address}.
@JsonSerializable()
final class FullStakeInfo {
  /// Volatile stake information.
  final StakeInfo volatile;

  /// "Persistent stake information.
  final StakeInfo persistent;

  const FullStakeInfo({
    required this.volatile,
    required this.persistent,
  });

  factory FullStakeInfo.fromJson(Map<String, dynamic> json) => _$FullStakeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FullStakeInfoToJson(this);
}
