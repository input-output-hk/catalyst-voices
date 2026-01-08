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
  @JsonKey(name: 'asset_name')
  final String assetName;

  /// Cardano native Asset Value
  final int amount;

  const StakedTxoAssetInfo({
    required this.policyHash,
    required this.assetName,
    required this.amount,
  });

  factory StakedTxoAssetInfo.fromJson(Map<String, dynamic> json) =>
      _$StakedTxoAssetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StakedTxoAssetInfoToJson(this);
}
