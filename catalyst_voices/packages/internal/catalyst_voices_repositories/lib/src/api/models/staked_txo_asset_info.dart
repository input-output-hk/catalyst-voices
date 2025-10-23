import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staked_txo_asset_info.g.dart';

/// User's staked txo asset info.
@JsonSerializable()
final class StakedTxoAssetInfo {
  /// 28 Byte Hash
  /// Asset policy hash (28 bytes).
  @JsonKey(name: 'policy_hash')
  final String policyHash;

  /// Cardano Native Asset Name
  /// Token policies Asset Name.
  @JsonKey(name: 'asset_name')
  final String assetName;

  /// Cardano native Asset Value
  /// Token Asset Value.
  final int amount;

  const StakedTxoAssetInfo({
    required this.policyHash,
    required this.assetName,
    required this.amount,
  });

  factory StakedTxoAssetInfo.fromJson(Json json) => _$StakedTxoAssetInfoFromJson(json);

  Json toJson() => _$StakedTxoAssetInfoToJson(this);
}
